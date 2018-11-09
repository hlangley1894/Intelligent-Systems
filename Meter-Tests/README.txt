#Meter-Tests

NOTE: In order to use clips_meter_testing.cpp in Visual Studio, the CLIPS source code must be compiled to retrieve CLIPS libraries. These libraries
can then be linked into Visual Studio.

This directory contains files related to the meter test intelligent system. This system takes in pre-formatted results from meter testing and
offers suggestions on what to do with each meter based on its results. If the meter passes all tests, then it is cleared to be sent to clients.
Otherwise, the intelligent system will alert the user why the meter failed and suggest an action to get the meter working.

meter_test.clp: CLIPS file containing intelligent system facts and rules.

clips_meter_testing.cpp: C++ file for use in Visual Studio to run meter_test.clp without the CLIPS IDE.
