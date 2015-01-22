/* This MEX function takes a set of indexes into an image, and the
	 image, then sums all values together that have the same index and
	 stores it at index position in a vector. */

#include "mex.h"
#include <math.h>
#include <string.h>

/* Arguments: LHS = sumvector, RHS = image, index */

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] ) {

  // Lets use double for image 
	int *index;
	double *image;
	double *sum;

  int i;
  int nIndexes;
	int nBins;

  if(nlhs != 1) {
    mexErrMsgIdAndTxt("MATLAB:sumImage:invalidNumOutputs", 
											"One output required.");
  }

  if(nrhs != 3) {
    mexErrMsgIdAndTxt("MATLAB:sumImage:invalidNumInputs", 
											"Three inputs required. First argument an image, second argument indexes (int32!!), third argument nBins (int).");
  }

  image = mxGetPr(prhs[0]);
	index = (int*) mxGetPr(prhs[1]);
	nBins = (int) mxGetScalar(prhs[2]);

	if(mxGetM(prhs[0]) != mxGetM(prhs[1]) || mxGetN(prhs[0]) != mxGetN(prhs[1])) {
		mexErrMsgIdAndTxt("MATLAB:sumImage:incorrectSize", 
											"The size of the first and second input arguments must match.");
		
	}

  if(!mxIsClass(prhs[0],"double")
		 || !mxIsClass(prhs[1],"int32")
		 || !mxIsClass(prhs[2],"int32")) {
		mexErrMsgIdAndTxt("MATLAB:sumImage:incorrectType", 
											"First double matrix, second int32 matrix, third int32 scalar");
		
	}


	nIndexes = mxGetM(prhs[1]) * mxGetN(prhs[1]);

	plhs[0] = mxCreateDoubleMatrix((mwSize) nBins, (mwSize) 1, mxREAL);

	sum = mxGetPr(plhs[0]);


	/* Do the work */

	for(i = 0; i < nIndexes; i++) {


		// printf("%d: %f ", i, image[i]);

		if(index[i]-1 >= nBins || index[i]-1 < 0) {
			// This should never happen!!
			printf("MEX error: i = %d, index[i] = %d, nBins = %d\n",
						 i, index[i], nBins);
			mexErrMsgTxt("BAD BAD BAD!!");
		}

		// Need to subtract 1 from index, because matlab start from 1, C from 0
		sum[index[i]-1] += image[i];

	}

}
