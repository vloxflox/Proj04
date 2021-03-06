#ifndef PLOTTER
#define PLOTTER
#include <iostream>
#include <fstream>

#include "vec3.h"

#include <vector>
#include <string>

using namespace std;
typedef vec3 Color;

class Plotter
{
private:
	vector<Color> colorBuffer;
	string fileName;

public:
	int xSize;
	int ySize;

	Plotter();

	Plotter(int,int,string);

	~Plotter();

	int matrixToLine(int, int);

	bool isValidLocation(int, int);

	void changePixel(int, int, Color);

	void clear();
	
	void plotFile();
};

#endif