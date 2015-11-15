// multArray.cpp


#include "multarray.h"

void MultArray( long mval, long array[], 
     long arraySize )
{
	for(int i = 0; i < arraySize; i++)
		array[i] *= mval;
}
