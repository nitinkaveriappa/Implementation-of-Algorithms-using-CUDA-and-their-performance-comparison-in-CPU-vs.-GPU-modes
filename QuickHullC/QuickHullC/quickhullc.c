#include<time.h>
#include<stdlib.h>
#include<stdio.h>
#include<math.h>
#include<gl/glut.h>
#define pi 22/7;

typedef struct 
{
double x;
double y;
}points;

//points pts[10010];

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
//test case 1 Denser points(70 pts)        cpu= 103ms
/*
points pts[]={3.0,3.0,4.0,6.0,1.0,2.0,5.0,4.0,7.0,3.0,6.0,6.0,1.0,1.0,2.0,1.0,6.0,7.0,8.0,8.0,5.0,5.0,9.0,4.0,7.0,5.0,1.0,10.0,2.0,7.0,5.0,2.0,2.0,4.0,8.0,6.0,3.0,6.0,4.0,
4.0,6.0,8.0,5.0,10.0,1.0,5.0,4.0,3.0,8.0,7.0,-2.0,20.0,9.0,0.0,-29.0,-17.0,17.0,29.0,2.0,3.0,16.0,7.0,19.0,7.0,8.0,9.0,19.0,25.0,23.0,4.0,17.0,27.0,18.0,26.0,6.0,4.0,12.0,
28.0,5.0,25.0,2.0,6.0,28.0,28.0,
16.0,18.0,8.0,12.0,7.0,15.0,3.0,2.0,9.0,1.0,14.0,5.0,4.0,17.0,2.0,18.0,7.0,7.0,14.0,9.0,-19.0,-23.0,12.0,-27.0,-15.0,12,-29,-29,-20,
16,25.0,20.0,14.0,9.0,1.0,3.0,9.0,22.0,6.0,2.0,7.0,14.0,19.0,1.0,17.0,14.0,8.0,15.0,25.0,2.0,18.0,1.0,3.0,18.0,12.0,28.0



//test case 2  distributed points(50 pts)        cpu=90ms

//points pts[]={
    -2.0,3.0,-15.0,-2.0,20.0,1.50,6.0,1.0,14.0,0.0,4.0,-2.30,-8.0,1.0,14.0,3.0,-24.0,-3.0,18.0,-2.0,-5.0,3.0,-3.0,5.0,7.0,6.0,16.0,21.0,32.0,15.0,42.0,19.0,22.0,33.0,
25.0,35.0,39.0,29.0,28.0,49.0,43.0,17.0,28.0,20.0,37.0,27.0,23.0,34.0,32.0,13.0,36.0,16.0,24.0,35.0,39.0,29.0,15.0,26.0,43.0,34.0,12.0,32.0,31.0,21.0,35.0,55.0,15.0,46.0,18.0,
23.0,2.0,58.0,3.0,38.0,45.0,2.0,1.0,2.0,52.0,5.0,56.0,36.0,52.0,12.0,12.0,59.0,59.0,2.0,41.0,19.0,36.0,-20.0,35.0,-2.0,-6.0,-15.0,20.0,-26.0,39.0 
*/

//test case 3 verticle points (50pts)        cpu=98ms

/*
points pts[]={

2.0,27.0,1.0,-29.0,0.25,-15.62,-0.0,16.45,-1.25,6.0,-1.5,16.0,-1.25,18.0,-1.0,18.75,-2.0,15.0,-1.60,18.0,2.0,-29.0,2.50,3.0,1.0,-23.0,-2.0,-17.0,-2.0,-4.0,-3.0,
25.0,-2.0,35.0,-4.0,48.0-2.0,-2.0,3.0,-4.0,32.0,0.0,-3.5,-2.5,26.0,2.0,1.0,-3.0,0.0,-3.2,26.0,-3.0,26.0,2.30,48.0,0.0,48.0,2.0,39.0,-3.0,19.0,-3.5,-19.0,-2.0,38.0,-3.0,
46.0,3.55,24.0,-1.0,17.0,4.0,15.0,3.0,3.0,-2.6,6.0,-1.0,38.0,1.0,54.0,1.0,48.0,-2.0,55.0,-3.99,16.0,2.0,17.0,0.0,36.0,4.01,58.0,2.0,59.0,2.0,36.0,0.0,39.0,1.0,22.0,-1.0,4.0,
4.0,9.0,-3.0,-27.0 

};
*/
//test case 4 horizontal points



//test case 5 curve edge        cpu=98ms

//points pts[]={
/*
    ,1.0,7.0,23.0,46.0,27.0,16.0,37.0,18.0,9.0,2.0,35.0,18.0,27.0,21.0,7.0,2.0,23.0,32.0,6.0,3.0,25.0,6.0,28.0,17.0,5.0,38.0,48.0,43.0,28.0,27.0,34.0,47.0,39.0,40.0,
35.0,8.0,34.0,32.0,3.0,4.0,3.0,5.0,16.0,9.0,35.0,24.0,1.0,24.0,46.0,29.0,43.0,15.0,32.0,5.0,17.0,16.0,26.0,48.0,29.0,30.0,36.0,24.0,4.0,3.0,12.0,12.0,5.0,8.0,27.0,46.0};
*/

//points pts[]={1.0,54.0,-29.0,-17.0,-2.0,55.0,2.0,59.0,4.01,58.0,3.0,3.0,-20.0,16.0};
points pt1,pt2,pt11,pt22,min,max;

int i,j,k,r=0,l2=0,count=0,f_r=0,screen1=0,screen2=0,n,input=0;
int n;
double m,c,temp_c,xx,yy;
points subset1[200],subset2[200],result[200]; 

       
void draw(points a,points c)
{
    glColor3f(0.0,0.0,0.0);
    for(i=0;i<n;i++)
    {
        glBegin(GL_POINTS);
        glVertex2d(pts[i].x,pts[i].y);       
        glEnd(); 
    }
    glBegin(GL_LINES);
    {
        glVertex2d(a.x,a.y);
        glVertex2d(c.x,c.y);
    }
    glEnd();
}

points minimum(points *pts,int n)
{
       //pt with min x

    points min_x=pts[0]; 

    for(i=0;i<n;i++)
    {
        if(pts[i].x < min_x.x)
        min_x=pts[i];
        else if(pts[i].x==min_x.x)
        {
            if(pts[i].y>min_x.y)
                min_x=pts[i];
        }
    }
    min=min_x;
    printf("(%.2f,%.2f) is min x \n",min_x);
    printf("(%.2f,%.2f) is min \n",min);
    result[f_r++]=min;
    return min;
}

points maximum(points *pts, int n, points min)
{
    double distance,max_distance=0.0;    //finding the max distance pt
    double dx,dy;    
    points max;
    for(i=0;i<n;i++)
    { 
        dx=min.x-pts[i].x;    //difference in x
        dy=min.y-pts[i].y;    //difference in y
        distance=sqrt((dx*dx)+(dy*dy));    //finding the distance using distance formula
        if(max_distance<distance)
        {
            max_distance=distance;
            max.x=pts[i].x;
            max.y=pts[i].y;
        }
    }
    printf("%.2f is max distance\n",max_distance);
    printf("(%.2f,%.2f) is max point\n",max);
    result[f_r++]=max;
    return max;
}

points subht(points *c,int j,points a,points b)
{
    double dx,dy,d_ab,t_ac,t_bc,area,s,max_h=0;
    double h[200];
    points pt;

    dx=a.x-b.x;    //difference in x
    dy=a.y-b.y;    //difference in y
    d_ab=sqrt((dx*dx)+(dy*dy));    //finding the distance using distance formula
    for(i=0;i<j;i++)    //find the point with max distance from the baseline
    {
                            //find the length of the sides of the triangle abc
        dx=a.x-c[i].x;
        dy=a.y-c[i].y;
        t_ac=sqrt((dx*dx)+(dy*dy));
        dx=b.x-c[i].x;
        dy=b.y-c[i].y;
        t_bc=sqrt((dx*dx)+(dy*dy));
        
                            //find the area of the triangle using formula area=sqrt(s(s-a)(s-b)(s-c))
        s=(d_ab+t_ac+t_bc)/2;
        area=sqrt((s*(s-d_ab)*(s-t_ac)*(s-t_bc)));
            
                            //find the height of the triangle
        h[i]=(area*2)/d_ab;

        if(h[i]>max_h)
        {
            max_h=h[i];
            pt.x=c[i].x;
            pt.y=c[i].y;
        }
    }

    printf("The maximum height is %.2f and point is (%.2f,%.2f)\n",max_h,pt);
    result[f_r++]=pt;
    return pt;
}

void division(points *pts, int n, points min, points max)
{    
    m=(double)(max.y-min.y)/(max.x-min.x);    //slope of the line
    c=(double)min.y-(m*min.x);    //constant of the line
    printf("Slope of the line %.2f \nConstant of the line %.2f \n",m,c);
    printf("(%.2f,%.2f)   (%.2f,%.2f)\n",min,max);
  
    j=0;k=0;
    for(i=0;i<n;i++)
    {
        temp_c=pts[i].y-(m*pts[i].x);    //y=mx+c 
        if(c-temp_c<0)                    //points above the line
        {    subset1[j].x=pts[i].x;
            subset1[j].y=pts[i].y;
            j++;
        }
        
        else if(c-temp_c>0)               //points below the line
        {    subset2[k].x=pts[i].x;
            subset2[k].y=pts[i].y;
            k++;

        }
    }    
    printf("Subset1:\n");
    for(i=0;i<j;i++)
    
    printf("%.2f,%.2f\n",subset1[i]);
    
    printf("j old:%d\n\n",j);
    printf("k old:%d\n\n",k);
    printf("Subset2:\n");
    for(i=0;i<k;i++)
    printf("(%.2f,%.2f)\n",subset2[i]);
    

    pt1=subht(subset1,j,min,max);
    pt2=subht(subset2,k,min,max);
}

void divsub1(points *pts,int j, points a,points b,points c)
{    
    int j2,k2,flag=0;
    double m1,c1,m2,c2,h_m1,h_m2,c_m2,temp_c1,temp_c2,temp_c3,temp_a,temp_b;
    points subsubset1[200],subsubset2[200];

    m1=(double)(c.y-a.y)/(c.x-a.x);    //slope of the line
    c1=(double)a.y-(m1*a.x);    //constant of the line
    printf("Slope of the line %.2f \nConstant of the line %.2f \n",m1,c1);
    printf("(%.2f,%.2f) , (%.2f,%.2f)\n",a,c);
    
    m2=(double)(c.y-b.y)/(c.x-b.x);    //slope of the line
    c2=(double)b.y-(m2*b.x);    //constant of the line
    printf("Slope of the line %.2f \nConstant of the line %.2f \n",m2,c2);
    printf("(%.2f,%.2f) , (%.2f,%.2f)\n",b,c);

    h_m1=(b.y-a.y)/(b.x-a.x);
    h_m2=-1/(h_m1);
    c_m2=(double)c.y-(h_m2*c.x);
    printf("Slope of the line %.2f \nConstant of the line %.2f \n",h_m2,c_m2);

    j2=0;k2=0;
    printf("J:%d\n\n",j);
    for(i=0;i<j;i++)
    {
        temp_c3=pts[i].y-(h_m2*pts[i].x);    //line hc
        temp_c2=pts[i].y-(m2*pts[i].x);    //line bc
        temp_c1=pts[i].y-(m1*pts[i].x);    //y=mx+c line a
        
        printf("point is:(%2.f,%2.f)\n",pts[i]);
        if((pts[i].x-c.x)!=0)        //infinte line
        {
        if(h_m2>0)//positive slope
        {    
            temp_a=a.y-(h_m2*a.x);
            temp_b=b.y-(h_m2*b.x);
            if(c_m2-temp_a>0 && c_m2-temp_b>0)    //below the + line   (5)
            {
                if(c_m2-temp_c3>0)    //below the + line
                {    
                    printf("1-111111111\n");
                    if(c1-temp_c1<0)    //above the line
                {    printf("1-222222\n");
                    subsubset1[j2].x=pts[i].x;
                    subsubset1[j2].y=pts[i].y;
                    j2++;
                    
                }
                }
            }
            if(c_m2-temp_c3<0)    //above the + line        (1a)
            {    
                printf("1-111111111\n");
                if(c1-temp_c1<0)    //above the line
                {    printf("1-222222\n");
                    subsubset1[j2].x=pts[i].x;
                    subsubset1[j2].y=pts[i].y;
                    j2++;
                }    
            }
            else if(c_m2-temp_c3>0)        //below the line +line
            {    
                printf("1-3333333\n");
                {
                if(m2<0)    //negative slope                
                {
                if(c2-temp_c2<0)    //above the line        (1b)
                {    printf("1-44444111111\n");
                    subsubset2[k2].x=pts[i].x;
                    subsubset2[k2].y=pts[i].y;
                    k2++;
                                    }
                }
                else if(m2>0)    //positive slope
                {
                if(c2-temp_c2>0)    //below the line        (1a)
                {    printf("1-4444422222\n");
                    subsubset2[k2].x=pts[i].x;
                    subsubset2[k2].y=pts[i].y;
                    k2++;
                }            
                }
                }
            }
        }

        else if(h_m2<0)        //negative slope
        {    
            temp_a=a.y-(h_m2*a.x);    //to check whether a lies above or below the -ve lope of h_m2
            if(c_m2-temp_a<0)        // subset1 lies above the h_m2 line
            {
                if(c_m2-temp_c3<0)        // above the line        (2a)
                {
                    if(m1>0)    //+ slope                (2a.2)
                    {
                    if(c1-temp_c1>0)        //    below the line
                    {
                        printf("32323232311111111111\n");
                        subsubset1[j2].x=pts[i].x;
                        subsubset1[j2].y=pts[i].y;
                        j2++;
                    }
                    }
                    else if(m1<0)    // - slope            (2a.1/2a.3)
                    {
                    if(c1-temp_c1>0)        //below the line
                    {
                        printf("3232323232222222222\n");
                        subsubset1[j2].x=pts[i].x;
                        subsubset1[j2].y=pts[i].y;
                        j2++;
                    }
                    }
                }
                else if(c_m2-temp_c3>0)        // below the line
                {    
                    if(m2<0)        //-ve line        (2a.3)
                    {    
                    if(c2-temp_c2<0)    //above the line
                    {
                        printf("31313133333333333333333\n");
                        subsubset2[k2].x=pts[i].x;
                        subsubset2[k2].y=pts[i].y;
                        k2++;
                    }
                    }
                    else if(m2>0)        //+ve line        (2a.1/2a.2)
                    {    
                    if(c2-temp_c2>0)    //below the line
                    {
                        printf("31313134444444444\n");
                        subsubset2[k2].x=pts[i].x;
                        subsubset2[k2].y=pts[i].y;
                        k2++;
                    }
                    }
                }
            }            //subset1 lies below h_m2
            else
            {
                if(c_m2-temp_c3>0)    //below the line -ve line
                {    
                    printf("1-55555555\n");
                    if(m1>0)    //positive slope
                    {                                            
                        if(c1-temp_c1<0)    //above the line    (2b.1)
                        {
                            printf("1-66666666\n");
                            subsubset1[j2].x=pts[i].x;
                            subsubset1[j2].y=pts[i].y;
                            j2++;
                        }
                    }
                    else if(m1<0)                                            
                    {
                        if(c1-temp_c1>0)    //below the line    (2b.2)
                        {    
                            printf("1-666666661111\n");
                            subsubset1[j2].x=pts[i].x;
                            subsubset1[j2].y=pts[i].y;
                            j2++;
                        }
                    }
                }
                else if(c_m2-temp_c3<0)    //above the line -ve line
                {    
                    printf("1-777777777\n");
                    if(c2-temp_c2<0)    //above the line            (2b.1/2b.2)
                    {        
                        printf("1-88888888\n");                                        // not working for two condition
                        subsubset2[k2].x=pts[i].x;
                        subsubset2[k2].y=pts[i].y;
                        k2++;
                    }
                }
            }
        }
        else if(h_m2==0)    //horizontal line        (3)
        {
            if(c.y-pts[i].y<0)    //above the horizontal line
            {    
                if(c1-temp_c1<0)    //above the line
                {
                    printf("1-999999\n");
                    subsubset1[j2].x=pts[i].x;
                    subsubset1[j2].y=pts[i].y;
                    j2++;
                }
            }
            else if(c.y-pts[i].y<0)            //below the horizontal line
            {
                if(c2-temp_c2>0)    //below the line
                {
                    printf("1-1010101\n");
                    subsubset2[k2].x=pts[i].x;
                    subsubset2[k2].y=pts[i].y;
                    k2++;
                }
            }
        }
        }
        else        //(4)
        {
            if(c.x-pts[i].x<0) //above the vertical line
            {    
                if(c1-temp_c1<0)        //above
                {
                    printf("1-12121212\n");
                    subsubset1[j2].x=pts[i].x;
                    subsubset1[j2].y=pts[i].y;
                    j2++;
                }
            }
            else if(c.x-pts[i].x>0)        //below the vertical line
            {
                if(c2-temp_c2>0)        //below
                {
                    printf("1-13131313\n");
                    subsubset2[k2].x=pts[i].x;
                    subsubset2[k2].y=pts[i].y;
                    k2++;
                }
            }
        }
    }
    
    if(j2!=0)
    {
        printf(" subset1:\n");
        for(i=0;i<j2;i++)
        printf("(%.2f,%.2f)\n",subsubset1[i]);
        pt11=subht(subsubset1,j2,a,c);
        divsub1(subsubset1,j2,a,c,pt11);
    }
    else
    {
        draw(a,c);
    }
    
    if(k2!=0)
    {
        printf(" subset2:\n");
        for(i=0;i<k2;i++)
        printf("(%.2f,%.2f)\n",subsubset2[i]);
        pt22=subht(subsubset2,k2,c,b);
        divsub1(subsubset2,k2,c,b,pt22);
    }
    else
    {
        draw(c,b);
    }

}

void divsub2(points *pts,int k, points a,points b,points c)
{
    int j2,k2;
    double m1,c1,m2,c2,h_m1,h_m2,c_m2,temp_c1,temp_c2,temp_c3,temp_a;
    points subsubset1[200],subsubset2[200];
        
    m1=(double)(c.y-a.y)/(c.x-a.x);    //slope of the line
    c1=(double)a.y-(m1*a.x);    //constant of the line
    printf("Slope of the line %.2f \nConstant of the line %.2f \n",m1,c1);
    printf("(%.2f,%.2f) , (%.2f,%.2f)\n",a,c);
    
    m2=(double)(c.y-b.y)/(c.x-b.x);    //slope of the line
    c2=(double)b.y-(m2*b.x);    //constant of the line
    printf("Slope of the line %.2f \nConstant of the line %f \n",m2,c2);
    printf("(%.2f,%.2f) , (%.2f,%.2f)\n",b,c);
    
    h_m1=(b.y-a.y)/(b.x-a.x);
    h_m2=-1/(h_m1);
    c_m2=(double)c.y-(h_m2*c.x);
    printf("Slope of the line %.2f \nConstant of the line %.2f \n",h_m2,c_m2);

    j2=0;k2=0;
    for(i=0;i<k;i++)
    {
        temp_c3=pts[i].y-(h_m2*pts[i].x);    //line hc
        temp_c2=pts[i].y-(m2*pts[i].x);    //line bc
        temp_c1=pts[i].y-(m1*pts[i].x);    //y=mx+c line ac
            
        if((pts[i].x-c.x)!=0)        //infinte line
        {
        if(h_m2>0)        //positive slope
        {    
            temp_a=a.y-(h_m2*a.x);
            if(c_m2-temp_a>0)        //below the line
            {
                 if(c_m2-temp_c3>0)            //below the +line        (1b)
                {
                    printf("fffffffffff \n");                
                    if(c1-temp_c1>0)    //below the line
                    {    
                        printf("2-1212121\n");
                        subsubset1[j2].x=pts[i].x;
                        subsubset1[j2].y=pts[i].y;
                        j2++;
                    }
                }
            else if(c_m2-temp_c3<0)        //above the +line
            {
                printf("kkkkkkkkkkkkk \n");
                if(c2-temp_c2<0)    //above the line
                {
                    printf("2-3232323232 \n");
                    subsubset2[k2].x=pts[i].x;
                    subsubset2[k2].y=pts[i].y;
                    k2++;
                }
            }
            }
            else if(c_m2-temp_a<0)        //above the line    (1a)
            {
            if(c_m2-temp_c3<0)        //above the +line
            {
                printf("2-11111 \n");
                if(c1-temp_c1>0)    //below the line
                {
                    printf("2-222222 \n");
                    subsubset1[j2].x=pts[i].x;
                    subsubset1[j2].y=pts[i].y;
                    j2++;
                }
            }
            else if(c_m2-temp_c3>0)            //below the +line
            {
                printf("2-333333 \n");                
                if(c2-temp_c2>0)    //below the line
                {    
                    printf("2-44444444444\n");
                    subsubset2[k2].x=pts[i].x;
                    subsubset2[k2].y=pts[i].y;
                    k2++;
                }
            }
            }
        }
        else if(h_m2<0)        //negative slope
        {    
            printf("2-55555555 \n");    
            if(c_m2-temp_c3>0)        //below the -line    (2a/2b)
            {
                printf("2-66666 \n");
                if(c1-temp_c1>0)    //below the line
                {
                    subsubset1[j2].x=pts[i].x;
                    subsubset1[j2].y=pts[i].y;
                    j2++;
                }
            }
            else if(c_m2-temp_c3<0)        //above the -line
            {    printf("2-77777777 \n");
                if(m2<0)        //negative slope    (2b)
                {
                if(c2-temp_c2<0)    //above the line
                {    
                    printf("2-88881111\n");
                    subsubset2[k2].x=pts[i].x;
                    subsubset2[k2].y=pts[i].y;
                    k2++;
                }
                }
                else if(m2>0)        //positive slope    (2a)
                {
                if(c2-temp_c2>0)    //below the line
                {
                    printf("2-888822222\n");
                    subsubset2[k2].x=pts[i].x;
                    subsubset2[k2].y=pts[i].y;
                    k2++;
                }
                }
            }
        }
        else if(h_m2==0)    //horizontal line    (3)
        {
            if(c.y-pts[i].y>0)    //below the horizontal line
            {    
                if(c1-temp_c1>0)    //below the line
                {
                    printf("2-999999\n");
                    subsubset1[j2].x=pts[i].x;
                    subsubset1[j2].y=pts[i].y;
                    j2++;
                }
            }
            else if(c.y-pts[i].y<0)        //above the horizontal line
            {
                if(c2-temp_c2>0)    //below the line
                {
                    printf("2-1010101\n");
                    subsubset2[k2].x=pts[i].x;
                    subsubset2[k2].y=pts[i].y;
                    k2++;
                }
            }
        }
        }
        else
        {
            if(c.x-pts[i].x>0) //below the vertical line
            {
                if(c1-temp_c1>0)        //below the line
                {    
                    printf("2-12121212\n");
                    subsubset1[j2].x=pts[i].x;
                    subsubset1[j2].y=pts[i].y;
                    j2++;
                }
            }
            else if(c.x-pts[i].x<0)        //above the vertical line    (4)
            {
                if(c2-temp_c2<0)        //above the line
                {
                    printf("1-13131313\n");
                    subsubset2[k2].x=pts[i].x;
                    subsubset2[k2].y=pts[i].y;
                    k2++;
                }
            }
        }
    }

    printf("j2:%d\n",j2);
    printf("k2:%d\n",k2);

    if(j2!=0)
    {
        printf("Subsubset1:\n");
        for(i=0;i<j2;i++)
        printf("(%.2f,%.2f)\n",subsubset1[i]);
        pt11=subht(subsubset1,j2,a,c);
        divsub2(subsubset1,j2,a,c,pt11);
    }
    else
    {
        draw(a,c);
    }

    if(k2!=0)
    {    
        printf("Subsubset2:\n");
        for(i=0;i<k2;i++)
        printf("(%.2f,%.2f)\n",subsubset2[i]);
        pt22=subht(subsubset2,k2,c,b);
        divsub2(subsubset2,k2,c,b,pt22);
    }
    else
    {
        draw(c,b);
    }
}

int main1()
{
    clock_t start=clock(),stop,t;
    double elapsed,xx=0,yy=0; 
    
  /*  int i,ti;
    t=clock();
    ti=(unsigned int)t;
    for(i=0;i<10000;i++)
    {
        ti++;
        srand(ti);
        xx= rand()%300+1;
        yy= rand()%300+1;
        pts[i].x=xx;
        pts[i].y=yy;
    }
    */
    n = (sizeof(pts)/sizeof(double))/2;
    printf("%d",n);

    min=minimum(pts,n);
    max=maximum(pts,n,min);
    division(pts,n,min,max);
    
    divsub1(subset1,j,min,max,pt1);
    divsub2(subset2,k,min,max,pt2);
    
    printf("final hull");
    for(i=0;i<f_r;i++)
    printf("(%.2f,%.2f)\n",result[i]);
    
    stop=clock();
    elapsed = (double)(stop - start) * 1000.0 / CLOCKS_PER_SEC;
    printf("Time elapsed in ms: %.2f", elapsed);

    return 0;
}

void keys(unsigned char key,int x,int y)
{
    if(key=='a')
    {
        screen2=1;
        glutPostRedisplay();
    }

}

void mydisplay()
{
    glClear(GL_COLOR_BUFFER_BIT);
    if(screen2==1)
    {
        main1();
        screen2=0;
    }
    glFlush();
}

void init()
{
    glMatrixMode(GL_PROJECTION);    
    glLoadIdentity(); 
    glPointSize(4.0);
    gluOrtho2D(-30,100,-30,100);  
    glClearColor(1.0,1.0,1.0,1.0);
    glColor3f(0.0,0.0,0.0); 
    glMatrixMode(GL_MODELVIEW);
}

int main(int argc,char **argv)
{
    glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB);      
    glutInitWindowSize(600,600);        
    glutInitWindowPosition(10,10); 
    glutCreateWindow("simple");
    glutKeyboardFunc(keys);
    glutDisplayFunc(mydisplay);  
    init(); 
    glutMainLoop();
}