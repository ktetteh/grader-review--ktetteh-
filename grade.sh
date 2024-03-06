CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
if [[ -f "student-submission/ListExamples.java" ]]
then
    cp student-submission/ListExamples.java grading-area/
    cp TestListExamples.java grading-area/
else
    echo "Wrong file submitted! Please submit the correct one!"
    exit 1
fi
pwd
cd grading-area/
pwd

CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'
javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
  echo "Program compiler failure! Check your code!"
  exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > testing-output.txt

if grep -q "OK" "testing-output.txt"  
then
  echo "The percentage correct is 100%!"
  exit 0
else
  lastline=$(cat testing-output.txt | tail -n 2 | head -n 1)
  tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
  failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
  successes=$((tests - failures))
  echo "The fraction correct is $successes / $tests"  
fi
