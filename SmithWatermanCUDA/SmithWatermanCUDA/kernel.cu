
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
//#include "timer.h"


#define CUDA_CHECK_RETURN(value) {											\
	cudaError_t _m_cudaStat = value;										\
	if (_m_cudaStat != cudaSuccess) {										\
		fprintf(stderr, "Error %s at line %d in file %s\n",					\
				cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);		\
		exit(1);															\
	} \
}

#define WORK_SIZE 100 * sizeof(char)

#define match 2
#define mismatch -1
/*char strA[100] = { 'a', 'g', 'c', 'a', 'c', 'a', 'c', 'a', 'a', 'g', 'c', 'a',
		'c', 'a', 'c', 'a', 'a', 'g', 'c', 'a', 'c', 'a', 'c', 'a', 'a', 'g',
		'c', 'a', 'c', 'a', 'c', 'a', 'a', 'g', 'c', 'a', 'c', 'a', 'c', 'a',
		'\0' };
char strB[100] = { 'a', 'g', 'c', 'a', 'c', 'a', 'a', 'a', 'a', 'c', 'a', 'c',
		'a', 'c', 't', 'a', 'a', 'c', 'a', 'c', 'a', 'c', 't', 'a', 'a', 'c',
		'a', 'c', 'a', 'c', 't', 'a', 'a', 'c', 'a', 'c', 'a', 'c', 't', 'a',
		'\0' };
*/
char strA[100] = { 'a', 'c', 'a', 'c', 't', 'a', 'g', 'a', 'c', 't', 'a', '\0' };
char strB[100] = { 'a', 'g', 'c', 'a', 'c', 'a', 'g', 'a', 'c', 'i', 'o', '\0' };


char strAF[100], strBF[100];
int i, j, k, l, m, lenA, lenB, compval;
int maximum = 0, mati, matj;
int SmatArray[100][100], AmatArray[100][100];

typedef struct {
	int x;
	int y;
} points;
points allignPts[100];

__global__ void localAllign(points *p_allignPts, char *p_strAF, char *p_strBF,
		char *p_strA, char *p_strB, int *p_m) {
	int index = threadIdx.x;
	if (((p_allignPts[index].x - p_allignPts[index + 1].x) == 1)
			&& ((p_allignPts[index].y - p_allignPts[index + 1].y) == 1)) {
		p_strAF[*p_m - index] = p_strA[(p_allignPts[index].x) - 1];
		p_strBF[*p_m - index] = p_strB[(p_allignPts[index].y) - 1];
	} else if (((p_allignPts[index].x - p_allignPts[index + 1].x) == 0)
			&& ((p_allignPts[index].y - p_allignPts[index + 1].y) == 1)) {
		p_strAF[*p_m - index] = '-';
		p_strBF[*p_m - index] = p_strB[(p_allignPts[index].y) - 1];
	} else if (((p_allignPts[index].x - p_allignPts[index + 1].x) == 1)
			&& ((p_allignPts[index].y - p_allignPts[index + 1].y) == 0)) {
		p_strAF[*p_m - index] = p_strA[(p_allignPts[index].x) - 1];
		p_strBF[*p_m - index] = '-';
	}
}

void scoringmat(char strA[100], char strB[100], int lenA, int lenB) {
	printf("Scoring Matrix");
	for (i = 0; i < lenA; i++) {
		SmatArray[0][i] = 0;
	}
	for (i = 0; i < lenB; i++) {
		SmatArray[i][0] = 0;
	}

	compval = 0;
	for (i = 1; i <= lenA; i++) {
		for (j = 1; j <= lenB; j++) {
			if (strA[i - 1] == strB[j - 1]) {
				compval = (SmatArray[i - 1][j - 1] + match);
			}
			if (compval < (SmatArray[i - 1][j] + mismatch)) {
				compval = (SmatArray[i - 1][j] + mismatch);
			}
			if (compval < (SmatArray[i][j - 1] + mismatch)) {
				compval = (SmatArray[i][j - 1] + mismatch);
			} else if (strA[i - 1] != strB[j - 1]) {
				compval = (SmatArray[i - 1][j - 1] + mismatch);
			}
			if (compval < (SmatArray[i - 1][j] + mismatch)) {
				compval = (SmatArray[i - 1][j] + mismatch);
			}
			if (compval < (SmatArray[i][j - 1] + mismatch)) {
				compval = (SmatArray[i][j - 1] + mismatch);
			}
			if (compval < 0) {
				compval = 0;
			}
			SmatArray[i][j] = compval;
			compval = 0;
		}
	}
	printf("\n");
	printf("   0");
	for (i = 0; i <= lenB; ++i) {
		printf("  %c", strB[i]);
	}
	printf("\n");
	for (i = 0; i < lenA; ++i) {
		if (i < 1) {
			printf("0");
		}
		if (i > 0) {
			printf("%c", strA[i - 1]);
		}
		for (j = 0; j < lenB; ++j) {
			printf("%3i", SmatArray[i][j]);
		}
		printf("\n");
	}
}

void allignmat() {
	for (i = 0; i < lenA; i++) {
		for (j = 0; j < lenB; j++) {
			if (SmatArray[i][j] > maximum) {
				maximum = SmatArray[i][j];
				mati = i;
				matj = j;
			}
		}
	}
	printf("matrix value=%d and cell value=%d %d\n", maximum, mati, matj);
	printf("\n");
	i = mati;
	j = matj;
	//printf("matrix value=%d\n",SmatArray[i][j]);
	k = 0;
	allignPts[k].x = i;
	allignPts[k].y = j;
	k++;
	while (SmatArray[i][j] != 0) {
		i = mati;
		j = matj;
		if ((SmatArray[i - 1][j - 1] >= SmatArray[i - 1][j])
				&& (SmatArray[i - 1][j - 1] >= SmatArray[i][j - 1])) {
			maximum = SmatArray[i - 1][j - 1];
			//printf("matrix value=%d\n ",max);
			allignPts[k].x = i - 1;
			allignPts[k].y = j - 1;
			k++;
			mati = i - 1;
			matj = j - 1;
		} else if ((SmatArray[i - 1][j] > SmatArray[i - 1][j - 1])
				&& (SmatArray[i - 1][j] > SmatArray[i][j - 1])) {
			maximum = SmatArray[i - 1][j];
			//printf("matrix value=%d\n ",max)l;
			allignPts[k].x = i - 1;
			allignPts[k].y = j;
			k++;
			mati = i - 1;
			matj = j;
		} else if ((SmatArray[i][j - 1] > SmatArray[i - 1][j - 1])
				&& (SmatArray[i][j - 1] > SmatArray[i - 1][j])) {
			maximum = SmatArray[i][j - 1];
			//printf("matrix value=%d\n ",max);
			allignPts[k].x = i;
			allignPts[k].y = j - 1;
			k++;
			mati = i;
			matj = j - 1;
		}
		i = i--;
		j = j--;
	}

	for (i = 0; i <= k; i++) {
		printf("(%d,%d)\n", allignPts[i]);
	}
	l = k - 1;
	printf("\nAllignment Matrix\n");
	printf("   0");
	for (i = 0; i <= lenB; ++i) {
		printf("  %c", strB[i]);
	}
	printf("\n");
	for (i = 0; i < lenA; ++i) {
		if (i < 1) {
			printf("0");
		}
		if (i > 0) {
			printf("%c", strA[i - 1]);
		}

		for (j = 0; j < lenB; ++j) {
			if (allignPts[k].x == i && allignPts[k].y == j) {
				printf("%3i", SmatArray[i][j]);
				k--;
			} else
				printf("  0");
		}
		printf("\n");
	}

}

int main(void) {
	clock_t start1,stop1;
	double elapsed1;
	printf("\tSMITH WATERMAN C PROGRAM\n\n");
	//printf("string1=agcacaca\n");
	//printf("string2=acacacta\n\n");

	lenA = strlen(strA) + 1;
	lenB = strlen(strB) + 1;
	//StartTimer();
	float elapsedTime;
	cudaEvent_t start,stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start,0);
	start1=clock();
	scoringmat(strA, strB, lenA, lenB);
	allignmat();

	m = l;
	points *d_allignPts;
	int *d_m;
	char *d_strA, *d_strB, *d_str_AF, *d_strBF;
	CUDA_CHECK_RETURN(cudaMalloc((void**) &d_allignPts, sizeof(allignPts)));
	CUDA_CHECK_RETURN(cudaMalloc((void**) &d_strA, WORK_SIZE));
	CUDA_CHECK_RETURN(cudaMalloc((void**) &d_strB, WORK_SIZE));
	CUDA_CHECK_RETURN(cudaMalloc((void**) &d_str_AF, WORK_SIZE));
	CUDA_CHECK_RETURN(cudaMalloc((void**) &d_strBF, WORK_SIZE));
	CUDA_CHECK_RETURN(cudaMalloc((void**) &d_m, sizeof(int)));
	CUDA_CHECK_RETURN(cudaMemcpy(d_allignPts, allignPts, sizeof(allignPts),
			cudaMemcpyHostToDevice));
	CUDA_CHECK_RETURN(cudaMemcpy(d_strA, strA, WORK_SIZE, cudaMemcpyHostToDevice));
	CUDA_CHECK_RETURN(cudaMemcpy(d_strB, strB, WORK_SIZE, cudaMemcpyHostToDevice));
	CUDA_CHECK_RETURN(cudaMemcpy(d_str_AF, strAF, WORK_SIZE, cudaMemcpyHostToDevice));
	CUDA_CHECK_RETURN(cudaMemcpy(d_strBF, strBF, WORK_SIZE, cudaMemcpyHostToDevice));
	CUDA_CHECK_RETURN(cudaMemcpy(d_m, &m, sizeof(int), cudaMemcpyHostToDevice));

	localAllign<<<1, m+1>>>(d_allignPts, d_str_AF, d_strBF, d_strA, d_strB, d_m);

	CUDA_CHECK_RETURN(cudaMemcpy(strAF, d_str_AF, WORK_SIZE, cudaMemcpyDeviceToHost));
	CUDA_CHECK_RETURN(cudaMemcpy(strBF, d_strBF, WORK_SIZE, cudaMemcpyDeviceToHost));
	cudaThreadSynchronize();
	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime,start,stop);
	stop1=clock();
	elapsed1=(double)(stop1-start1)*1000.0/CLOCKS_PER_SEC;
	printf("\nTime elapsed in ms: %.2f\n",elapsed1);
	//printf("Time Taken = %f ms",elapsedTime);
	printf("\nOptimal Local Alignment of Sequences A & B\nSeqA: ");
	for (i = 0; i <= m+1; i++) {
		printf("%c", strAF[i]);
	}
	printf("\nSeqB: ");
	for (i = 0; i <= m+1; i++) {
		printf("%c", strBF[i]);
	}
	printf("\n");

	//double runtime = GetTimer();
	//printf(" total: %f s\n", runtime / 1000);

	CUDA_CHECK_RETURN(cudaFree(d_m));
	CUDA_CHECK_RETURN(cudaFree(d_allignPts));
	CUDA_CHECK_RETURN(cudaFree(d_strA));
	CUDA_CHECK_RETURN(cudaFree(d_strB));
	CUDA_CHECK_RETURN(cudaFree(d_str_AF));
	CUDA_CHECK_RETURN(cudaFree(d_strBF));
	cudaDeviceReset();
	return 0;
}