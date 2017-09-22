/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* % Introduction to Matlab Mex
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %% Compilation */
//% mex -g -ldl CFLAGS="\$CFLAGS -std=c99" Mex_tutorial.c
//or
//% mex Mex_tutorial.c


/* Mandatory header */
#include <mex.h>

/* Mex-files always require a gateway function that controls the passage of data between Matlab and the C program
 The function always has the same prototype
 All input and output variables are passed as pointers
 Nevertheless the function is called as [outputs] = Mex_tutorial(inputs) */

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    // nlhs : number of output (left hand side)
    // nrhs : number of input (right hand side)
    // plhs, prhs: arrays of pointers to the variables
    
    /*  check for proper number of arguments. For one input, two outputs*/
    if (nrhs!=2)
        mexErrMsgTxt("Two inputs required.");
    if (nlhs!=1)
        mexErrMsgTxt("One output required.");
    
    // To access the ith data with an mxArray
    double* a = mxGetPr(prhs[0]);
    if (!mxIsDouble(prhs[0])) {
        mexErrMsgTxt("Input data (scalar, vector, matrix or image) should be double.\n");
    }
    // For int16: mxIsUint16...
    // To access the ith data with an mxArray
    // double* a = mxGetptr(prhs[i]);
    
    // To know the number of dimensions of the data (2 for grayscale images, 3 for color)
    const int number_of_dims = mxGetNumberOfDimensions(prhs[0]);
    const int *dim_array = mxGetDimensions(prhs[0]); //array of size number_of_dims, each dimension contains the number of elments in this dimension in the Matlab data type; e.g. dim_array[0] = height, dim_array[1] = width

    
    
    
    // To create a 2D matrix of doubles
    double *p = (double*) mxCreateDoubleMatrix(10, 10, mxREAL); //initialise the memory to zero
    // To create higher dimensional matrices mxCreateNumericArray
    double* q = (double*) mxCreateNumericArray(number_of_dims,dim_array,mxDOUBLE_CLASS, mxREAL);
    
    // To return these created matrices
    plhs[0] = (mxArray *) p;
    double* b = (double*)mxGetPr(plhs[0]);
	// to return as the jth output argument
    // double* b = (double*)mxGetPr(plhs[j]);
    
    // To duplicate an array
    /* Get the target image and its dimensions  - Duplicate it for the output */
    plhs[1]= mxDuplicateArray((mxArray *)  a); // or (prhs[i]);
    double* c = (double*)mxGetPr(plhs[1]);
    
    
    /* Working with an image */
    // An image is stored as a vector
    // To convert i,j coordinates of the matrix to the vector coordinates: i*width+j
    // Be careful, in Matlab coordinates start at 1, and in C at 0
    
}