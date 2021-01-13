// Name: Siddharth Singh Ahluwalia
// Roll No.: CS19BTECH11056

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/*function prototypes*/
void assending(int a[], int n);
void decending(int a[], int n);
void randomising(int a[], int n);
int insertion_sort(int a[], int n);
void swap(int *a, int *b);
void print_array(int a[], int n);

/* gives number of required for given array to sort by insertion sort algorithm */
int insertion_sort(int a[], int n)
{
	int compare = 0;
	int key;

	for(int i=1; i<n; i++)
	{
		key = a[i];
		int j = i - 1;
		while((j>=0) && (compare++) && (a[j]>key))
		{
			a[j+1] = a[j];
			j--;
		}
		a[j+1] = key;
	}
	return compare;
}

/* prints increasing sequence along with number of comparisions */
void assending(int a[], int n)
{
	int increase[n];
	/* copy elements of array to another array */
	for(int i=0; i<n; i++)
	{
		increase[i] = a[i];
	}
	print_array(a, n);

	printf("%d\n", insertion_sort(a, n));
}

/* prints decreasing sequence along with number of comparisions */
void decending(int a[], int n)
{
	int decrease[n];
	/* copy elements of array to another array in decreasing order */
	for(int i=0; i<n; i++)
	{
		decrease[n-1-i] = a[i];
	}
	print_array(decrease, n);

	printf("%d\n", insertion_sort(decrease, n));
}

/* prints random sequence along with number of comparisions */
void randomising(int ar[], int n)
{
	srand(time(NULL));

	int r[n];
	int a;
	/* copy elements of array to another array */
	for(int i=0; i<n; i++)
	{
		r[i] = ar[i];
	}
	/*Fisher-Yates shuffle algorithm*/
	for(int i=n-1; i>0; i--)
	{
		a = rand() % (i+1);
		
		swap(&r[a], &r[i]);
	}
	print_array(r, n);
	printf("%d\n", insertion_sort(r, n));
}

// swaps two elements
void swap(int *a, int *b)
{
	int temp = *a;
	*a = *b;
	*b = temp;
}

// prints array 
void print_array(int a[], int n)
{
	for(int i=0; i<n; i++)
	{
		printf("%d ", a[i]);
	}
	printf("\n");
}

int main()
{
	int a, r, n;
	printf("Enter n, a and r\n");
	scanf("%d %d %d", &n, &a, &r);

	int arr[n];
	arr[0] = a;
	for(int i=1; i<n; i++)
	{
		arr[i] = arr[i-1]*r;
	}
	assending(arr, n);
	decending(arr, n);
	randomising(arr, n);

	return 0;
}