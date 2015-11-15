// main.cpp - Testing the LongestIncreasingSequence subroutine.

// Solution to Chapter 13 programming exercise 2.

#include <iostream>
#include "sumarrays.h"
using namespace std;

int main()
{
	const unsigned ARRAY_SIZE = 10; 
	long array1[] = {-5, 10, 20, 14, 17, 26, 42, 22, 19, -5 };
	long array2[] = {2, 5, 2, 4, 7, 6, 4, 12, 9, -5 };
	long array3[] = {3, 4, 5, 6, 7, 8, 10, 20, 3, 4 };

// Test the Assembly language subroutine

	SumThreeArrays( array1, array2, array3, ARRAY_SIZE );

	for(unsigned i = 0; i < ARRAY_SIZE; i++)
		cout << array1[i] << ", ";

	cout << endl;
	
	return 0;
}