#include<time.h>
#include<stdlib.h>
#include<stdio.h>
#include<math.h>
#include<GL/glut.h>
#include <cuda.h>
//#include "timer.h"
#define pi 22/7;

typedef struct {
	double x;
	double y;
} points;

typedef struct {
	double x;
	double y;
	double largest;
} kernel_shared_type;

//points pts[100];
//test case 1
points pts[] = { 3.0, 3.0, 4.0, 6.0, 1.0, 2.0, 5.0, 4.0, 7.0, 3.0, 6.0, 6.0,
		1.0, 1.0, 2.0, 1.0, 6.0, 7.0, 8.0, 8.0, 5.0, 5.0,

		9.0, 4.0, 7.0, 5.0, 1.0, 10.0, 2.0, 7.0, 5.0, 2.0, 2.0, 4.0, 8.0, 6.0,
		3.0, 6.0, 4.0, 4.0, 6.0, 8.0, 5.0, 10.0, 1.0, 5.0, 4.0, 3.0, 8.0, 7.0,

		-2.0, 20.0, 9.0, 0.0, -29.0, -17.0, 17.0, 29.0, 2.0, 3.0, 16.0, 7.0,
		19.0, 7.0, 8.0, 9.0, 19.0, 25.0, 23.0, 4.0, 17.0, 27.0, 18.0, 26.0, 6.0,
		4.0, 12.0, 28.0, 5.0, 25.0, 2.0, 6.0, 28.0, 28.0, 20.0, 15.0, 16.0,
		18.0, 8.0, 12.0, 7.0, 15.0, 3.0, 2.0, 9.0, 1.0, 14.0, 5.0, 4.0, 17.0,
		2.0, 18.0, 7.0, 7.0, 14.0, 9.0, -19.0, -23.0, 12.0, -27.0, -15.0, 12,
		-29, -29, -20, 16, 25.0, 20.0, 14.0, 9.0, 1.0, 3.0, 9.0, 22.0, 6.0, 2.0,
		7.0, 14.0, 19.0, 1.0, 17.0, 14.0, 8.0, 15.0, 25.0, 2.0, 18.0, 1.0, 3.0,
		18.0 };

//test case 2
//points pts[]={-2.0,3.0,-15.0,-2.0,20.0,1.50,6.0,1.0,14.0,0.0,4.0,-2.30,-8.0,1.0,14.0,3.0,-24.0,-3.0,18.0,-2.0,-5.0,3.0,-36.0,23.0,7.0,6.0,16.0,21.0,32.0,15.0,42.0,19.0,22.0,33.0,25.0,35.0,39.0,29.0,28.0,49.0,43.0,17.0,28.0,20.0,37.0,27.0,23.0,34.0,32.0,13.0,36.0,16.0,24.0,35.0,39.0,29.0,15.0,26.0,43.0,34.0,12.0,32.0,31.0,21.0,35.0};	//horizontal points

//test case 3
//points pts[]={2.0,27.0,1.0,-29.0,0.25,-15.62,-0.0,16.45,-1.25,6.0,-1.5,16.0,-1.25,18.0,-1.0,18.75,-2.0,15.0,-1.60,18.0,2.0,-29.0,1.0,-23.0,-2.0,-17.0,-2.0,24.0};//vertical lines

//test case 4
//points pts[]={1.0,7.0,23.0,46.0,27.0,16.0,37.0,18.0,9.0,2.0,35.0,18.0,27.0,21.0,7.0,2.0,23.0,32.0,6.0,3.0,25.0,6.0,28.0,17.0,5.0,38.0,48.0,43.0,28.0,27.0,34.0,47.0,39.0,40.0,35.0,8.0,34.0,32.0,3.0,4.0,3.0,5.0,16.0,9.0,35.0,24.0,1.0,24.0,46.0,29.0,43.0,15.0,32.0,5.0,17.0,16.0,26.0,48.0,29.0,30.0,36.0,24.0,4.0,3.0,12.0,12.0,5.0,8.0,27.0,46.0};

points pt1, pt2, pt11, pt22, smallest, largest;

int i, j, k, r = 0, l2 = 0, count = 0, f_r = 0, screen1 = 0, screen2 = 0, n,
		input = 0;
//int n;
double m, c, temp_c, xx, yy; //m1,c1,m2,c2,temp_c,temp_c1,temp_c2,temp_c3,c_m2,h_m1,h_m2;
points subset1[100], subset2[100], result[100]; //,subsubset1[100],subsubset2[100],result[100];;

/*void getRandomPoints(int n,int xmax,int ymax)
 {

 for (i = 0; i < n; i++)
 {
 xx=rand()%ymax;
 yy=rand()%xmax;
 pts[i].x=xx;
 pts[i].y=yy;
 }
 //points.push( [ xMax /4 + r * Math.cos(theta), yMax/2 + 2 * r * Math.sin(theta) ] )
 }
 /* var phase = Math.random() * Math.PI * 2;
 for (var i = 0; i < numPoint/2; i++) {
 var r =  Math.random()*xMax/4;
 var theta = Math.random() * 1.5 * Math.PI + phase;
 points.push( [ xMax /4 * 3 +  r * Math.cos(theta), yMax/2 +  r * Math.sin(theta) ] )
 }*/

/*void show(points pts[],int n)
 {
 int i;
 printf("N:%d \n",n);*/

void draw(points a, points c) {
	glColor3f(0.0, 0.0, 0.0);
	for (i = 0; i < n; i++) {
		glBegin(GL_POINTS);
		glVertex2d(pts[i].x, pts[i].y);
		glEnd();
	}
	glBegin(GL_LINES);
	{
		glVertex2d(a.x, a.y);
		glVertex2d(c.x, c.y);
	}
	glEnd();
}

points minimum(points *pts, int n) {
	points smallest_x = pts[0];    //pt with smallest x
//	points smallest_y=pts[0];    //pt wit smallest y
	points smallest;

	printf("The Points are: \n");
	for (i = 0; i < n; i++)
		printf("(%.2f,%.2f)\n", pts[i]);

	for (i = 0; i < n; i++) {
		if (pts[i].x < smallest_x.x)
			smallest_x = pts[i];
		else if (pts[i].x == smallest_x.x) {
			if (pts[i].y > smallest_x.y)
				smallest_x = pts[i];
		}
		//if(pts[i].y < smallest_y.y)
		//smallest_y=pts[i];
	}
	printf("(%.2f,%.2f) is smallest x \n", smallest_x);
	//printf("(%.2f,%.2f) is smallest y \n",smallest_y);

	//if((smallest_x.x < smallest_y.x)&&(smallest_x.y < smallest_y.y))    //compares the smallest in x & y and finalize the smallest
	smallest = smallest_x;
	//else
	//smallest=smallest_y;
	//show(pts,n);
	printf("(%.2f,%.2f) is smallest \n", smallest);
	result[f_r++] = smallest;
	return smallest;
}

points maximum(points *pts, int n, points smallest) {
	double distance, largest_distance = 0.0;    //finding the largest distance pt
	double dx, dy;
	points largest;
	for (i = 0; i < n; i++) {
		dx = smallest.x - pts[i].x;    //difference in x
		dy = smallest.y - pts[i].y;    //difference in y
		distance = sqrt((dx * dx) + (dy * dy)); //finding the distance using distance formula
		if (largest_distance < distance) {
			largest_distance = distance;
			largest.x = pts[i].x;
			largest.y = pts[i].y;
		}
	}
	printf("%.2f is largest distance\n", largest_distance);
	printf("(%.2f,%.2f) is largest point\n", largest);
	result[f_r++] = largest;
	return largest;
}

__global__ void subhtKernel(double *d_ab, points *pt, points *a, points *b,
		points *c, int *limit, double *largest) {
	extern __shared__ kernel_shared_type sdata[];
	unsigned int tid = threadIdx.x;
	if (tid < *limit) {
		double dx, dy, t_ac, t_bc, s, area;
		double h;
		dx = a->x - c[tid].x;
		dy = a->y - c[tid].y;
		t_ac = sqrt((dx * dx) + (dy * dy));
		dx = b->x - c[tid].x;
		dy = b->y - c[tid].y;
		t_bc = sqrt((dx * dx) + (dy * dy));
		s = (*d_ab + t_ac + t_bc) / 2;
		area = sqrt(s * (s - *d_ab) * (s - t_ac) * (s - t_bc));
		h = (area * 2) / *d_ab;
		sdata[tid].largest = h;
		sdata[tid].x = c[tid].x;
		sdata[tid].y = c[tid].y;
		__syncthreads();
		for (unsigned int s = *limit / 2; s >= 1; s = s / 2) {
			if (tid < s) {
				if (sdata[tid].largest < sdata[tid + s].largest) {
					sdata[tid].largest = sdata[tid + s].largest;
					sdata[tid].x = sdata[tid + s].x;
					sdata[tid].y = sdata[tid + s].y;
				}
			}
			__syncthreads();
		}
		__syncthreads();
		if (tid == 0) {
			*largest = sdata[0].largest;
			pt->x = sdata[0].x;
			pt->y = sdata[0].y;
		}
	}
}

points subht(points *c, int j, points a, points b) {
	double dx, dy, d_ab, t_ac, t_bc, area, s, largest_h;
	points pt;

	dx = a.x - b.x;    //difference in x
	dy = a.y - b.y;    //difference in y
	d_ab = sqrt((dx * dx) + (dy * dy)); //finding the distance using distance formula

	double *d_d_ab, *d_largest_h;
	int *d_j;
	points *d_pt, *d_a, *d_b, *d_c;

	cudaMalloc((void**) &d_d_ab, sizeof(double));
	cudaMalloc((void**) &d_largest_h, sizeof(double));
	cudaMalloc((void**) &d_j, sizeof(int));
	cudaMalloc((void**) &d_pt, sizeof(points));
	cudaMalloc((void**) &d_a, sizeof(points));
	cudaMalloc((void**) &d_b, sizeof(points));
	cudaMalloc((void**) &d_c, sizeof(points) * 100);

	cudaMemcpy(d_d_ab, &d_ab, sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(d_j, &j, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_a, &a, sizeof(points), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, &b, sizeof(points), cudaMemcpyHostToDevice);
	cudaMemcpy(d_c, c, sizeof(points) * 100, cudaMemcpyHostToDevice);

	unsigned int shared_size = sizeof(points) * j * j; 

	subhtKernel<<<1, j, shared_size>>>(d_d_ab, d_pt, d_a, d_b, d_c, d_j,
			d_largest_h);

	cudaDeviceSynchronize();
	cudaMemcpy(&largest_h, d_largest_h, sizeof(double), cudaMemcpyDeviceToHost);
	cudaMemcpy(&pt, d_pt, sizeof(points), cudaMemcpyDeviceToHost);
	cudaFree(d_d_ab);
	cudaFree(d_largest_h);
	cudaFree(d_j);
	cudaFree(d_pt);
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	printf("The maximum height is %.2f and point is (%.2f,%.2f)\n", largest_h,
			pt);
	result[f_r++] = pt;
	return pt;
}

void division(points *pts, int n, points smallest, points largest) {
	m = (double) (largest.y - smallest.y) / (largest.x - smallest.x);    //slope of the line
	c = (double) smallest.y - (m * smallest.x);    //constant of the line
	printf("Slope of the line %.2f \nConstant of the line %.2f \n", m, c);
	printf("(%.2f,%.2f)   (%.2f,%.2f)\n", smallest, largest);

	j = 0;
	k = 0;
#pragma acc parallel loop
	for (i = 0; i < n; i++) {
		temp_c = pts[i].y - (m * pts[i].x);	//y=mx+c
		if (c - temp_c < 0)                    //points above the line
				{
			subset1[j].x = pts[i].x;
			subset1[j].y = pts[i].y;
			j++;
		} else if (c - temp_c > 0)               //points below the line
				{
			subset2[k].x = pts[i].x;
			subset2[k].y = pts[i].y;
			k++;
		}
	}
	printf("Subset1:\n");
	for (i = 0; i < j; i++)
		printf("(%.2f,%.2f)\n", subset1[i]);
	printf("j old:%d\n\n", j);
	printf("k old:%d\n\n", k);
	printf("Subset2:\n");
	for (i = 0; i < k; i++)
		printf("(%.2f,%.2f)\n", subset2[i]);

	pt1 = subht(subset1, j, smallest, largest);
	pt2 = subht(subset2, k, smallest, largest);
}

void divsub1(points *pts, int j, points a, points b, points c) {
	int j2, k2, flag = 0;
	double m1, c1, m2, c2, h_m1, h_m2, c_m2, temp_c1, temp_c2, temp_c3;
	points subsubset1[100], subsubset2[100];

	m1 = (double) (c.y - a.y) / (c.x - a.x);    //slope of the line
	c1 = (double) a.y - (m1 * a.x);    //constant of the line
	printf("Slope of the line %.2f \nConstant of the line %.2f \n", m1, c1);
	printf("(%.2f,%.2f) , (%.2f,%.2f)\n", a, c);

	m2 = (double) (c.y - b.y) / (c.x - b.x);    //slope of the line
	c2 = (double) b.y - (m2 * b.x);    //constant of the line
	printf("Slope of the line %.2f \nConstant of the line %.2f \n", m2, c2);
	printf("(%.2f,%.2f) , (%.2f,%.2f)\n", b, c);

	h_m1 = (b.y - a.y) / (b.x - a.x);
	h_m2 = -1 / (h_m1);
	c_m2 = (double) c.y - (h_m2 * c.x);
	printf("Slope of the line %.2f \nConstant of the line %.2f \n", h_m2, c_m2);

	j2 = 0;
	k2 = 0;
	printf("J:%d\n\n", j);
#pragma acc parallel loop
	for (i = 0; i < j; i++) {
		temp_c3 = pts[i].y - (h_m2 * pts[i].x);	//line hc
		temp_c2 = pts[i].y - (m2 * pts[i].x);	//line bc
		temp_c1 = pts[i].y - (m1 * pts[i].x);	//y=mx+c line a

		printf("point is:(%2.f,%2.f)\n", pts[i]);
		if ((pts[i].x - c.x) != 0)		//infinte line
				{
			if (h_m2 > 0)		//positive slope
					{
				if (c_m2 - temp_c3 < 0)	//above the + line
						{
					printf("1-111111111\n");
					if (c1 - temp_c1 < 0)	//above the line
							{
						printf("1-222222\n");
						subsubset1[j2].x = pts[i].x;
						subsubset1[j2].y = pts[i].y;
						j2++;
						//flag=1;
					}
				} else if (c_m2 - temp_c3 > 0)		//below the line +line
						{
					printf("1-3333333\n");
					{
						if (m2 < 0)	//negative slope
								{
							if (c2 - temp_c2 < 0)	//above the line
									{
								printf("1-44444111111\n");
								subsubset2[k2].x = pts[i].x;
								subsubset2[k2].y = pts[i].y;
								k2++;
								//flag=1;
							}
						} else if (m2 > 0)	//positive slope
								{
							if (c2 - temp_c2 > 0)	//below the line
									{
								printf("1-4444422222\n");
								subsubset2[k2].x = pts[i].x;
								subsubset2[k2].y = pts[i].y;
								k2++;
								//flag=1;
							}
						}
					}
					/*else

					 {
					 */
				}
			}

			else if (h_m2 < 0)		//negative slope
					{
				if (c_m2 - temp_c3 > 0)	//below the line -ve line
						{
					printf("1-55555555\n");
					if (m1 > 0)	//positive slope
							{
						if (c1 - temp_c1 < 0)	//above the line
								{
							printf("1-66666666\n");
							subsubset1[j2].x = pts[i].x;
							subsubset1[j2].y = pts[i].y;
							j2++;
						}
					} else if (m1 < 0) {
						if (c1 - temp_c1 > 0)	//below the line
								{
							printf("1-66666666\n");
							subsubset1[j2].x = pts[i].x;
							subsubset1[j2].y = pts[i].y;
							j2++;
						}
					}
				} else if (c_m2 - temp_c3 < 0)	//above the line -ve line
						{
					printf("1-777777777\n");
					if (c2 - temp_c2 < 0)	//above the line
							{
						printf("1-88888888\n");
						subsubset2[k2].x = pts[i].x;
						subsubset2[k2].y = pts[i].y;
						k2++;
					}
				}
			} else if (h_m2 == 0)	//horizontal line
					{
				if (c.y - pts[i].y < 0)	//above the horizontal line
						{
					if (c1 - temp_c1 < 0)	//above the line
							{
						printf("1-999999\n");
						subsubset1[j2].x = pts[i].x;
						subsubset1[j2].y = pts[i].y;
						j2++;
					}
				} else if (c.y - pts[i].y < 0)		//below the horizontal line
						{
					if (c2 - temp_c2 > 0)	//below the line
							{
						printf("1-1010101\n");
						subsubset2[k2].x = pts[i].x;
						subsubset2[k2].y = pts[i].y;
						k2++;
					}
				}
			}
		} else {
			if (c.x - pts[i].x < 0) //above the vertical line
					{
				if (c1 - temp_c1 < 0)		//above
						{
					printf("1-12121212\n");
					subsubset1[j2].x = pts[i].x;
					subsubset1[j2].y = pts[i].y;
					j2++;
				}
			} else if (c.x - pts[i].x > 0)		//below the vertical line
					{
				if (c2 - temp_c2 > 0)		//below
						{
					printf("1-13131313\n");
					subsubset2[k2].x = pts[i].x;
					subsubset2[k2].y = pts[i].y;
					k2++;
				}
			}
		}
	}

	if (j2 != 0) {
		printf(" subset1:\n");
		for (i = 0; i < j2; i++)
			printf("(%.2f,%.2f)\n", subsubset1[i]);
		pt11 = subht(subsubset1, j2, a, c);
		divsub1(subsubset1, j2, a, c, pt11);
	} else {
		draw(a, c);
	}

	if (k2 != 0) {
		printf(" subset2:\n");
		for (i = 0; i < k2; i++)
			printf("(%.2f,%.2f)\n", subsubset2[i]);
		pt22 = subht(subsubset2, k2, c, b);
		divsub1(subsubset2, k2, c, b, pt22);
	} else {
		draw(c, b);
	}

}

void divsub2(points *pts, int k, points a, points b, points c) {
	int j2, k2;
	double m1, c1, m2, c2, h_m1, h_m2, c_m2, temp_c1, temp_c2, temp_c3;
	points subsubset1[100], subsubset2[100];

	m1 = (double) (c.y - a.y) / (c.x - a.x);    //slope of the line
	c1 = (double) a.y - (m1 * a.x);    //constant of the line
	printf("Slope of the line %.2f \nConstant of the line %.2f \n", m1, c1);
	printf("(%.2f,%.2f) , (%.2f,%.2f)\n", a, c);

	m2 = (double) (c.y - b.y) / (c.x - b.x);    //slope of the line
	c2 = (double) b.y - (m2 * b.x);    //constant of the line
	printf("Slope of the line %.2f \nConstant of the line %f \n", m2, c2);
	printf("(%.2f,%.2f) , (%.2f,%.2f)\n", b, c);

	h_m1 = (b.y - a.y) / (b.x - a.x);
	h_m2 = -1 / (h_m1);
	c_m2 = (double) c.y - (h_m2 * c.x);
	printf("Slope of the line %.2f \nConstant of the line %.2f \n", h_m2, c_m2);

	j2 = 0;
	k2 = 0;
	for (i = 0; i < k; i++) {
		temp_c3 = pts[i].y - (h_m2 * pts[i].x);	//line hc
		temp_c2 = pts[i].y - (m2 * pts[i].x);	//line bc
		temp_c1 = pts[i].y - (m1 * pts[i].x);	//y=mx+c line ac
		printf("temp_c2,(pt),index==%f,(%.2f,%.2f),%d\n", temp_c2, pts[i], i);

		if ((pts[i].x - c.x) != 0)		//infinte line
				{
			if (h_m2 > 0)		//positive slope
					{
				if (c_m2 - temp_c3 < 0)		//above the +line
						{
					printf("2-11111 \n");
					if (c1 - temp_c1 > 0)	//below the line
							{
						printf("2-222222 \n");
						subsubset1[j2].x = pts[i].x;
						subsubset1[j2].y = pts[i].y;
						j2++;
					}
				} else if (c_m2 - temp_c3 > 0)			//below the +line
						{
					printf("2-333333 \n");
					if (c2 - temp_c2 > 0)	//below the line
							{
						printf("2-44444444444\n");
						subsubset2[k2].x = pts[i].x;
						subsubset2[k2].y = pts[i].y;
						k2++;
					}
				}
			} else if (h_m2 < 0)		//negative slope
					{
				printf("2-55555555 \n");
				if (c_m2 - temp_c3 > 0)		//below the -line
						{
					printf("2-66666 \n");
					if (c1 - temp_c1 > 0)	//below the line
							{
						subsubset1[j2].x = pts[i].x;
						subsubset1[j2].y = pts[i].y;
						j2++;
					}
				} else if (c_m2 - temp_c3 < 0)		//above the -line
						{
					printf("2-77777777 \n");
					if (m2 < 0)		//negative slope
							{
						if (c2 - temp_c2 < 0)	//above the line
								{
							printf("2-88881111\n");
							subsubset2[k2].x = pts[i].x;
							subsubset2[k2].y = pts[i].y;
							k2++;
						}
					} else if (m2 > 0)		//positive slope
							{
						if (c2 - temp_c2 > 0)	//below the line
								{
							printf("2-888822222\n");
							subsubset2[k2].x = pts[i].x;
							subsubset2[k2].y = pts[i].y;
							k2++;
						}
					}
				}
			} else if (h_m2 == 0)	//horizontal line
					{
				if (c.y - pts[i].y > 0)	//below the horizontal line
						{
					if (c1 - temp_c1 > 0)	//below the line
							{
						printf("2-999999\n");
						subsubset1[j2].x = pts[i].x;
						subsubset1[j2].y = pts[i].y;
						j2++;
					}
				} else if (c.y - pts[i].y < 0)		//above the horizontal line
						{
					if (c2 - temp_c2 > 0)	//below the line
							{
						printf("2-1010101\n");
						subsubset2[k2].x = pts[i].x;
						subsubset2[k2].y = pts[i].y;
						k2++;
					}
				}
			}
		} else {
			if (c.x - pts[i].x > 0) //below the vertical line
					{
				if (c1 - temp_c1 > 0)		//below the line
						{
					printf("2-12121212\n");
					subsubset1[j2].x = pts[i].x;
					subsubset1[j2].y = pts[i].y;
					j2++;
				}
			} else if (c.x - pts[i].x < 0)		//above the vertical line
					{
				if (c2 - temp_c2 < 0)		//above the line
						{
					printf("1-13131313\n");
					subsubset2[k2].x = pts[i].x;
					subsubset2[k2].y = pts[i].y;
					k2++;
				}
			}
		}
	}

	printf("j2:%d\n", j2);
	printf("k2:%d\n", k2);

	if (j2 != 0) {
		printf("Subsubset1:\n");
		for (i = 0; i < j2; i++)
			printf("(%.2f,%.2f)\n", subsubset1[i]);
		pt11 = subht(subsubset1, j2, a, c);
		divsub2(subsubset1, j2, a, c, pt11);
	} else {
		draw(a, c);
	}

	if (k2 != 0) {
		printf("Subsubset2:\n");
		for (i = 0; i < k2; i++)
			printf("(%.2f,%.2f)\n", subsubset2[i]);
		pt22 = subht(subsubset2, k2, c, b);
		divsub2(subsubset2, k2, c, b, pt22);
	} else {
		draw(c, b);
	}
}

int main1() {
	/*clock_t start = clock(), stop, t;*/
	double elapsed, xx = 0, yy = 0;

	//clock_t t;
	/*int i,ti;
	 t=clock();
	 ti=(unsigned int)t;
	 for(i=0;i<50;i++)
	 {
	 ti++;
	 srand(ti);
	 xx= rand()%50+1;
	 yy= rand()%50+1;
	 pts[i].x=xx;
	 pts[i].y=yy;
	 }
	 */

	float elapsedTime;
	
cudaEvent_t start,stop;
	
cudaEventCreate(&start);
	
cudaEventCreate(&stop);
	
cudaEventRecord(start,0);
	n = (sizeof(pts) / sizeof(double)) / 2;

	smallest = minimum(pts, n);
	largest = maximum(pts, n, smallest);
	division(pts, n, smallest, largest);

	divsub1(subset1, j, smallest, largest, pt1);
	divsub2(subset2, k, smallest, largest, pt2);

	printf("final hull");
	for (i = 0; i < f_r; i++)
		printf("(%.2f,%.2f)\n", result[i]);

	cudaThreadSynchronize();
	
cudaEventRecord(stop,0);
	
cudaEventSynchronize(stop);
	
cudaEventElapsedTime(&elapsedTime,start,stop);
	
printf("Time Taken = %f ms",elapsedTime);

	//stop = clock();
	//elapsed = (double) (stop - start) * 1000.0 / CLOCKS_PER_SEC;
	//printf("Time elapsed in ms: %.2f", elapsed);

	return 0;
}

void keys(unsigned char key, int x, int y) {
	/*if(key=='s')
	 {
	 screen1=1;
	 glutPostRedisplay();
	 }*/
	if (key == 'a') {
		screen2 = 1;
		glutPostRedisplay();
	}
	/*if(key=='i')
	 {
	 input=1;
	 glutPostRedisplay();
	 }*/

}

void mydisplay() {
	glClear(GL_COLOR_BUFFER_BIT);
	/*if(screen1==1)
	 {
	 show(pts,n);
	 screen1=0;
	 }*/
	if (screen2 == 1) {
		//show(pts,n);
		main1();
		screen2 = 0;
	}
	/*if(input==1)
	 {
	 getRandomPoints(20,25.00,25.00);
	 input=0;
	 }*/
//screen=0;
	glFlush();
}

void init() {
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glPointSize(4.0);
	gluOrtho2D(-60, 60, -60, 60);
	glClearColor(1.0, 1.0, 1.0, 1.0);
	glColor3f(0.0, 0.0, 0.0);
	glMatrixMode(GL_MODELVIEW);
	//  glLoadIdentity();
}

int main(int argc, char **argv) {
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowSize(600, 600);
	glutInitWindowPosition(10, 10);
	glutCreateWindow("simple");
	glutKeyboardFunc(keys);
	glutDisplayFunc(mydisplay);
	init();
	glutMainLoop();
}

