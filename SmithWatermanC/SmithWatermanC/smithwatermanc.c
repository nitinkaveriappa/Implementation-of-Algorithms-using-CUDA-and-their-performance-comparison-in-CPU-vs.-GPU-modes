#include<stdio.h>
#include<string.h>
#include<time.h>
#define match 2
#define mismatch -1
char strA[100] = { 'a', 'c', 'a', 'c', 't', 'a', 'g', 'a', 'c', 't', 'a', '\0' };
char strB[100] = { 'a', 'g', 'c', 'a', 'c', 'a', 'g', 'a', 'c', 'i', 'o', '\0' };
/*
char strA[100] = { 'a', 'g', 'c', 'a', 'c', 'a', 'c', 'a', 'a', 'g', 'c', 'a',
		'c', 'a', 'c', 'a', 'a', 'g', 'c', 'a', 'c', 'a', 'c', 'a', 'a', 'g',
		'c', 'a', 'c', 'a', 'c', 'a', 'a', 'g', 'c', 'a', 'c', 'a', 'c', 'a',
		'\0' };
char strB[100] = { 'a', 'g', 'c', 'a', 'c', 'a', 'a', 'a', 'a', 'c', 'a', 'c',
		'a', 'c', 't', 'a', 'a', 'c', 'a', 'c', 'a', 'c', 't', 'a', 'a', 'c',
		'a', 'c', 'a', 'c', 't', 'a', 'a', 'c', 'a', 'c', 'a', 'c', 't', 'a',
		'\0' };
*/
//char strA[20],strB[20];
char strAF[100],strBF[100];
int i,j,k,l,m,lenA,lenB,compval;
int max=0,mati,matj;
int SmatArray[100][100],AmatArray[100][100];
typedef struct
{
	int x;
	int y;
}points;
points allignPts[100];

void scoringmat(char strA[100],char strB[100],int lenA,int lenB)
{
	printf("Scoring Matrix");
	for(i=0;i<lenA;i++)
	{
		SmatArray[0][i]=0;
	}
	for(i=0;i<lenB;i++)
	{
		SmatArray[i][0]=0;
	}

	compval=0;
	for(i=1;i<=lenA;i++)
	{
		for(j=1;j<=lenB;j++)
		{
			if(strA[i-1]==strB[j-1])
			{
				compval=(SmatArray[i-1][j-1]+match);
			}
			if(compval < (SmatArray[i-1][j]+mismatch))
			{
				compval = (SmatArray[i-1][j]+mismatch);
			}
			if(compval < (SmatArray[i][j-1]+mismatch))
			{
				compval = (SmatArray[i][j-1]+mismatch);
			}
			else if(strA[i-1]!=strB[j-1])
			{
				compval=(SmatArray[i-1][j-1]+mismatch);
			}
			if(compval < (SmatArray[i-1][j]+mismatch))
			{
				compval = (SmatArray[i-1][j]+mismatch);
			}
			if(compval < (SmatArray[i][j-1]+mismatch))
			{
				compval = (SmatArray[i][j-1]+mismatch);
			}
			if(compval<0)
			{
				compval=0;
			}
			SmatArray[i][j]=compval;
			compval=0;
		}
	}
	printf("\n");
	printf("   0");
	for(i=0;i<=lenB;++i)
	{
		printf("  %c",strB[i]);
	}
	printf("\n");
	for(i=0;i<lenA;++i)
	{
		if(i<1)
		{
			printf("0");
		}
		if(i>0)
		{
			printf("%c",strA[i-1]);
		}
		for(j=0;j<lenB;++j)
		{
			printf("%3i",SmatArray[i][j]);
		}
		printf("\n");
	}
}

void allignmat()
{
	for(i=0;i<lenA;i++)
	{
		for(j=0;j<lenB;j++)
		{
			if(SmatArray[i][j]>max)
			{
				max=SmatArray[i][j];
				mati=i;
				matj=j;
			}
		}
	}
	printf("matrix value=%d and cell value=%d %d\n",max,mati,matj);
	printf("\n");
	i=mati;
    j=matj;
	//printf("matrix value=%d\n",SmatArray[i][j]);
	k=0;
	allignPts[k].x=i;
	allignPts[k].y=j;
	k++;
	while(SmatArray[i][j]!=0)
	{
		i=mati;
		j=matj;
		if((SmatArray[i-1][j-1]>=SmatArray[i-1][j]) && (SmatArray[i-1][j-1]>=SmatArray[i][j-1]))
		{
			max=SmatArray[i-1][j-1];
			//printf("matrix value=%d\n ",max);
			allignPts[k].x=i-1;
			allignPts[k].y=j-1;
			k++;
			mati=i-1;
			matj=j-1;
		}
		else if((SmatArray[i-1][j]>SmatArray[i-1][j-1]) && (SmatArray[i-1][j]>SmatArray[i][j-1]))
		{
			max=SmatArray[i-1][j];
			//printf("matrix value=%d\n ",max);
			allignPts[k].x=i-1;
			allignPts[k].y=j;
			k++;
			mati=i-1;
			matj=j;
		}
		else if((SmatArray[i][j-1]>SmatArray[i-1][j-1]) && (SmatArray[i][j-1]>SmatArray[i-1][j]))
		{
			max=SmatArray[i][j-1];
			//printf("matrix value=%d\n ",max);
			allignPts[k].x=i;
			allignPts[k].y=j-1;
			k++;
			mati=i;
			matj=j-1;
		}
		i=i--;
		j=j--;
	}
	
	for(i=0;i<k;i++)
	{
		printf("(%d,%d)\n",allignPts[i]);
	}
	l=k-1;
	printf("\nAllignment Matrix\n");
	printf("   0");
	for(i=0;i<=lenB;++i)
	{
		printf("  %c",strB[i]);
	}
	printf("\n");
	for(i=0;i<lenA;++i)
	{
		if(i<1)
		{
			printf("0");
		}
		if(i>0)
		{
			printf("%c",strA[i-1]);
		}

		for(j=0;j<lenB;++j)
		{
		if(allignPts[l].x==i && allignPts[l].y==j)
		{
			printf("%3i",SmatArray[i][j]);
			l--;
		}
		else 
			printf("  0");
		}
		printf("\n");
	}

}

void localAllign()
{
	m=k-1;
	for(i=0;i<=(k-1);i++)
	{
		if(((allignPts[i].x-allignPts[i+1].x)==1) && ((allignPts[i].y-allignPts[i+1].y)==1))
		{
			strAF[m]=strA[(allignPts[i].x)-1];
	        strBF[m]=strB[(allignPts[i].y)-1];
			m--;
		}
		if(((allignPts[i].x-allignPts[i+1].x)==0) && ((allignPts[i].y-allignPts[i+1].y)==1))
		{
			strAF[m]='-';
			strBF[m]=strB[(allignPts[i].y)-1];
			m--;
		}
		if(((allignPts[i].x-allignPts[i+1].x)==1) && ((allignPts[i].y-allignPts[i+1].y)==0))
		{
			strAF[m]=strA[(allignPts[i].x)-1];
			strBF[m]='-';
			m--;
		}
		
	}
	printf("\nOptimal Local Allignment of Sequences A & B\nSeqA: ");
	for(i=0;i<=(k-1);i++)
		printf("%c",strAF[i]);
	printf("\nSeqB: ");
	for(i=0;i<=(k-1);i++)
		printf("%c",strBF[i]);
	printf("\n");
}


int main()
{
	clock_t start,stop;
	double elapsed;
	printf("\tSMITH WATERMAN C PROGRAM\n\n");
	/*printf("enter string1:");
	fgets(strA,sizeof(strA),stdin);
	printf("enter string2:");
	fgets(strB,sizeof(strB),stdin);
	*/
	lenA=strlen(strA)+1;
	lenB=strlen(strB)+1;
	//lenA=strlen(strA);
	//lenB=strlen(strB);
	start=clock();
	scoringmat(strA,strB,lenA,lenB);
	allignmat();
	localAllign();
	stop=clock();
	elapsed=(double)(stop-start)*1000.0/CLOCKS_PER_SEC;
	printf("\nTime elapsed in ms: %.2f\n",elapsed);
	return 0;
}