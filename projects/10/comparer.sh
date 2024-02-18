echo "1. Squire"
echo "--------------------------------"
for file in Square/*T.xml; do
  printf "$file "
  sh ../../tools/TextComparer.sh $file $file.expected
done

echo "\n2. ArrayTest"
echo "--------------------------------"
for file in ArrayTest/*T.xml; do
  printf "$file "
  sh ../../tools/TextComparer.sh $file $file.expected
done

echo "\n3. ExpressionLessSquare"
echo "--------------------------------"
for file in ExpressionLessSquare/*T.xml; do
  printf "$file "
  sh ../../tools/TextComparer.sh $file $file.expected
done

