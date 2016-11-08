#include<stdio.h>
#include<stdlib.h>
#include<time.h>
//#include<windows.h>
//#include<string.h>
#include<gl/glut.h>
#include <cuda.h>
#include <curand_kernel.h>
//#include<math.h>
//using namespace std;
int map[500][500];
int screen=0,number1;

void myinit(void)
{
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(-50,50,0,200,-10,10);
	glClearColor(0.0,0.0,0.0,1.0);
	 glColor3f(1.0, 0.0, 0.0);
	//glColor3f(1.0,1.0,1.0);
	glMatrixMode(GL_MODELVIEW);
	
}

__global__ void diamondKernel(int *d_map, int *d_minimum, int *d_s_size,curandState *devState) {
	int left, right, up, down, val[4], avg;

	int row = (blockIdx.y * blockDim.y + threadIdx.y) * (*d_s_size)	+ (*d_minimum);
	//row += blockDim.y * gridDim.y;
	int col = (blockIdx.x * blockDim.x + threadIdx.x) * (*d_s_size)	+ (*d_minimum);
	//col += blockDim.x * gridDim.x;

	if(row < (*d_s_size - *d_minimum))
	{
		if(col < (*d_s_size - *d_minimum)) {
//		curandState s;
		int seed = row * col;
		curand_init(seed, 0, 0, (devState + row)+col);
		left = row - *d_minimum;
		right = row + *d_minimum;
		up = col - *d_minimum;
		down = col + *d_minimum;

		// the four corner values
		val[0] = *((d_map + left) + up);   // upper left
		val[1] = *((d_map + left) + down); // lower left
		val[2] = *((d_map + right) + up);  // upper right
		val[3] = *((d_map + right) + down);  // lower right

		avg = (val[0] + val[1] + val[2] + val[3]) / 4;
		//srand(ti);
		int temp = (int)((curand_uniform((devState + row)+col))*10000)%25;
		//printf("%d\n",number1);
		//atomicAdd((d_map + row) + col,(avg+temp));
		*((d_map + row) + col) = avg + temp;
	}
	}
}

void diamond(int size, int minimum, int maximum, int iterations) {
//	clock_t t;
	int i,j;
	int s_size;
//	t = clock();
	//ti = (unsigned int) t;
//	int seed = (unsigned int) t;
	curandState *devState;
	//printf("diamond\n");
	s_size = (1 << iterations) + 1;

	int *d_map, *d_minimum, *d_s_size;
	cudaMalloc((void**)&d_map, sizeof(int) * 500 * 500);
	cudaMalloc((void**)&d_minimum, sizeof(int));
	cudaMalloc((void**)&d_s_size, sizeof(int));
	cudaMalloc((void**)&devState, (s_size - minimum) * (s_size - minimum) * sizeof(curandState));
	cudaMemcpy(d_map, map, sizeof(map), cudaMemcpyHostToDevice);
	cudaMemcpy(d_minimum, &minimum, sizeof(minimum), cudaMemcpyHostToDevice);
	cudaMemcpy(d_s_size, &s_size, sizeof(s_size), cudaMemcpyHostToDevice);

	dim3 dimGrid(1, 1);
	dim3 blockDimensional(s_size - minimum, s_size - minimum);

	diamondKernel<<<1, blockDimensional>>>(d_map, d_minimum, d_s_size,devState);
	cudaDeviceSynchronize();

	cudaMemcpy(map, d_map, sizeof(int) * 500 * 500, cudaMemcpyDeviceToHost);
	//	printf(cudaGetErrorString(cudaGetLastError()));

	cudaFree(d_map);
	cudaFree(d_minimum);
	cudaFree(d_s_size);
	cudaFree(devState);

//pc
//	for (x = minumum; x < (s_size - minumum); x += size) {
//		for (y = minumum; y < (s_size - minumum); y += size) {
//			left = x - minumum;
//			right = x + minumum;
//			up = y - minumum;
//			down = y + minumum;
//
//			// the four corner values
//			val1 = map[left][up];   // upper left
//			val2 = map[left][down]; // lower left
//			val3 = map[right][up];  // upper right
//			val4 = map[right][down];  // lower right
//
//			avg = (val1 + val2 + val3 + val4) / 4;
//			srand(ti);
//			number1 = rand() % 25;
//			//printf("%d\n",number1);
//			map[x][y] = avg + number1;
//			ti++;
//
//		}
//	}

	for( i=0;i<=maximum;i++)
	 {
	 for( j=0;j<=maximum;j++)
	 {
	 printf("   %d",map[i][j]);
	 }
	 printf("\n");
	 }
	/*printf(
			"\n***************************************************************************");*/
	/*for (int i = 0; i <= maximum; i++) {
		for (int j = 0; j <= maximum; j++) {
			printf("   %d", map[i][j]);
		}
		printf("\n");
	}
	printf(
			"\n***************************************************************************");*/

}


void squareStepEven(int min,int size,int max,int iterations)
 {
	 clock_t t;
	int ti,x,y,s_size,left,right,up,down,val1,val2,val3,val4,avg,i,j;
	t=clock();
	ti=(unsigned int)t;
	// printf("square1\n");
	  s_size=(1<<iterations)+1 ;
          for ( x = min; x < s_size; x += size)
		  {
               for (y = 0; y < s_size; y += size)
			   {
                    if (y == max)
					{
                         map[x][y] = map[x][0];
                         continue;
                    }

                     left = x - min;
                     right = x + min;
                     down = y + min;
                     up = 0;

                    if (y == 0)
					{
                         up = max-min;
                    } else 
					{
                         up = y - min;
                    }

                    // the four corner values
                     val1 = map[left][y]; // left
                     val2 = map[x][up];   // up
                     val3 = map[right][y];// right   
				     val4 = map[x][down]; // down
			    avg=(val1+val2+val3+val4)/4;
			   srand (ti);
				number1 = rand() % 25;
				//printf("%d\n",number1);
                    map[x][y]=avg+number1;
					ti++;
			   }

		  }
		  
		/*  for(i=0;i<=max;i++)
	{
		for(j=0;j<=max;j++)
			{
				printf("   %d",map[i][j]);
			}
		printf("\n");
		  }*/
 }
 void squareStepOdd(int min, int size,int max,int iterations)
 {
	 clock_t t;
	int ti,x,y,i,j,s_size,left,right,down,up,avg,val1,val2,val3,val4;
	t=clock();
	ti=(unsigned int)t;
	  s_size=(1<<iterations)+1 ;
	// printf("square2\n");
	 printf("size=%d \n",size);
          for ( x = 0; x < s_size; x += size)
		  {
               for ( y = min; y < s_size; y += size)
			   {
                    if (x == max)
					{
                         map[x][y] = map[0][y];
                         continue;
					}

                     left = 0;
                     right = x + min;
                     down = y + min;
                     up = y - min;

                    if (x == 0)
					{
                         left = max - min;
                    } else
					{
                         left = x - min;
                    }

                    // the four corner values
                     val1 = map[left][y]; // left
                     val2 = map[x][up];   // up
                     val3 = map[right][y];// right
                     val4 = map[x][down]; // down
					 avg=(val1+val2+val3+val4)/4;
					srand (ti);
					number1 = rand() % 25;
					//printf("%d\n",number1);
                    map[x][y]=avg+number1;
					ti++;
			   }
		  }
		 
	/*	  for( i=0;i<=max;i++)
	{
		for( j=0;j<=max;j++)
			{
				printf("   %d",map[i][j]);
			}
		printf("\n");
		  }*/
 }
 void makeMap(int iterations,int seed)
{
	clock_t start=clock(),stop;
	double elapsed;
	//printf("this s construction\n");
	int size,minCoordinate,maxIndex,i,j;
	//int **map;
	size=(1<<iterations)+1;
	//int **map=new int *[size];
	printf("size is %d \n",size);
	//for( i=0;i<size;i++)
		//map[i]=new int[size];
	for( i=0;i<size;i++)
		for( j=0;j<size;j++)
			map[i][j]=0;
	 maxIndex=size-1;
	 printf("maxIndex:%d",maxIndex);

	 map[0][0]=seed;
	 map[0][maxIndex]=seed;
	 map[maxIndex][maxIndex]=seed;
	 map[maxIndex][0]=seed;
	/* for( i=0;i<size;i++)
	{
		for( j=0;j<size;j++)
			{
				printf("   %d",map[i][j]);
			}
		printf("\n");
	 }*/
	
	for( i=1;i<=iterations;i++)
	{
		minCoordinate=maxIndex>>i;
		size=minCoordinate<<1;
		//printf("size=%d",size);
		diamond(size,minCoordinate,maxIndex,iterations);
		//printf("size=%d",size);
		squareStepEven(minCoordinate,size,maxIndex,iterations);
		//printf("size=%d",size);
		squareStepOdd(minCoordinate,size,maxIndex,iterations);
	}
	printf("end\n");
	/*for( i=0;i<=maxIndex;i++)
	{
		for( j=0;j<=maxIndex;j++)
			{
				printf("   %d",map[i][j]);
			}
		printf("\n");
	}*/
	stop=clock();
	elapsed = (double)(stop - start) * 1000.0 / CLOCKS_PER_SEC;
    printf("Time elapsed in ms: %.2f", elapsed);
 }




 void keys(unsigned char key,int x,int y)
 {
	// int **map;
	 if(key=='a')
	 {
		 screen=1;
		 glutPostRedisplay();
	 }
 }

 void display()
 {
	//int ** map;
	int size,s,i,j;
	GLfloat x,z,step;
	

	
	//int s=50;
	 if(screen==1)
	 {
	 //map=makeMap(5,50);
  //glColor3fv(c);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	size=(1<<5)+1;
	makeMap(5,50);
	 s=size-1;
	 step = (GLfloat)2*s / size;
     x = -(GLfloat)s;
     z = -(GLfloat)s;
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    glBegin(GL_QUADS);
    for ( i = 0; i < s; i++) 
	{
        for ( j = 0; j < s; j++) 
		{
		glColor3f(i/50.0,j/16000.0,map[i][j]/16000.00);
            glVertex3f(x, map[i][j], z);
            glVertex3f(x, map[i][j+1], z+step);
            glVertex3f(x+step, map[i+1][j+1], z+step);
            glVertex3f(x+step, map[i+1][j], z);

            z += step;
        }
        x += step;
        z = -(GLfloat)s;
    }
	 }
    glEnd();
	screen=0;
	glutPostRedisplay();
	glFlush();
 }

 int main(int argc,char ** argv)
{
    glutInit(&argc,argv);
	glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB|GLUT_DEPTH);
	glutInitWindowSize(500,500);
	glutCreateWindow("terrains");
	glutKeyboardFunc(keys);
	glutDisplayFunc(display);
	glEnable(GL_DEPTH_TEST);
	myinit();
	glutMainLoop();
}