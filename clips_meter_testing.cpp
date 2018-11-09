// clips_meter_testing.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <windows.h>
#include <string>
#include <fstream>
#include <iostream>
#include <stdio.h>
#include "clips.h"

//include library file for CLIPS functions
extern "C"
{
#include "CLIPSDLL.h"
}

int main()
{
	//create environment variable for current instance of clips
	void *theEnvironment;
	theEnvironment = __CreateEnvironment();

	//load clips file
	__EnvLoad(theEnvironment, "meter_test.clp");

	//reset clips
	__EnvReset(theEnvironment);

	//run clips and end output to text file
	__EnvRun(theEnvironment, -1); 
	
	//destroy environment memory
	__DestroyEnvironment(theEnvironment);

	//hold console window open
	std::cout << "Finished. Press enter to exit...\n";
	std::cin.get();

    return 0;
}

