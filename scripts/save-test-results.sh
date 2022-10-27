#!/bin/sh

echo $1
if [ ! -d $1 ] 
then
	echo "Directory $1 DOES NOT exists"
	exit 1
fi

TEST_REPORTS_DIR=$1

if [ "${TEST_REPORTS_DIR: -1}" = "/" ] 
then
	TEST_REPORTS_DIR=${TEST_REPORTS_DIR:0:-1}
fi

echo $TEST_REPORTS_DIR
TEST_REPORTS_DIR=$TEST_REPORTS_DIR-test-results
echo "rm -R $TEST_REPORTS_DIR"
mkdir $TEST_REPORTS_DIR
TEST_REPORTS_DIR=../`basename $TEST_REPORTS_DIR`
echo $TEST_REPORTS_DIR

# Enter glibc directory and copy results files
cd $1
rg -lg '*.test-result' '^FAIL' | while read i; do cp --parents ${i/.test-result/.out} $i $TEST_REPORTS_DIR; done
rg -lg '*.test-result' '^XFAIL' | while read i; do cp --parents ${i/.test-result/.out} $i $TEST_REPORTS_DIR; done

# Just use the result of make check

# Or generate result test.sum (can be used to update results)
rg --sort path --max-depth 1 -lg '*.test-result' "" | while read i; do head -1 $i >> $TEST_REPORTS_DIR/tests.tmp; done
rg --sort path -lg '*.test-result' "" | while read i; do head -1 $i >> $TEST_REPORTS_DIR/tests.tmp; done

# Remove duplicates
awk '!x[$0]++' $TEST_REPORTS_DIR/tests.tmp > $TEST_REPORTS_DIR/tests.sum
rm $TEST_REPORTS_DIR/tests.tmp


cat $TEST_REPORTS_DIR/tests.sum | grep -w PASS > $TEST_REPORTS_DIR/tests-pass.sum
cat $TEST_REPORTS_DIR/tests.sum | grep -w FAIL > $TEST_REPORTS_DIR/tests-fails.sum
cat $TEST_REPORTS_DIR/tests.sum | grep -w XFAIL > $TEST_REPORTS_DIR/tests-xfails.sum
cat $TEST_REPORTS_DIR/tests.sum | grep -w UNSUPPORTED > $TEST_REPORTS_DIR/tests-unsupported.sum

FINAL_REPORT=summary-report.txt

echo "Summary of test results:" > $TEST_REPORTS_DIR/$FINAL_REPORT
echo "   " `cat $TEST_REPORTS_DIR/tests.sum | grep -w FAIL | wc -l` " FAIL" >> $TEST_REPORTS_DIR/$FINAL_REPORT
echo "   " `cat $TEST_REPORTS_DIR/tests.sum | grep -w PASS | wc -l` " PASS" >> $TEST_REPORTS_DIR/$FINAL_REPORT
echo "   " `cat $TEST_REPORTS_DIR/tests.sum | grep -w UNSUPPORTED | wc -l` " UNSUPPORTED" >> $TEST_REPORTS_DIR/$FINAL_REPORT
echo "   " `cat $TEST_REPORTS_DIR/tests.sum | grep -w XFAIL | wc -l` " XFAIL" >> $TEST_REPORTS_DIR/$FINAL_REPORT
echo "   " `cat $TEST_REPORTS_DIR/tests.sum | grep -w XPASS | wc -l` " XPASS" >> $TEST_REPORTS_DIR/$FINAL_REPORT
