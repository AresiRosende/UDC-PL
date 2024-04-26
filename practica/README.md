# F1 Timing Flex/Bison Analyzer

This program was made using both Flex and Bison.
The goal of it is to analyze a given xml file containing the timing on each lap of a driver and check if the values are valid. If they are, it will return the laps in which the driver made the fastests sectors and lap and the compound they were using

## XML Template
The admited xml files must have the following syntax
```
<?xml version="1.0" encoding="UTF-8"?>
<race>
	<circuit></circuit>
	<totalLaps></totalLaps>
	<driverNum></driverNum>
	<driverName></driverName>
	<laps>
		<lap>
			<lapNumber></lapNumber>
			<incidencies></incidencies>
			<lapInfo>
				<tyre></tyre>
				<tyreLife></tyreLife>
				<sector1></sector1>
				<sector2></sector2>
				<sector3></sector3>
				<lapTime></lapTime>
			</lapInfo>
		</lap>
	</laps>
</race>
```
- totalLaps, driverNum, lapNumber and tyreLife only accept positive integers of 1 to 3 digits
- circuit and driverName only accept letter from the english language and the space character
- incidencies only accept the following values
	- RedFlag
	- YellowFlag
	- TrackLimits
	- PIT_STOP
	- DNF
	- DSQ
	- LAPPED
	- (*empty*)
- tyre only accepts the following values
	- C1, C2, C3, C4 or C5
	- FW (full wet)
	- IM (intermediate)
- The time for the sectors and lapTime has to be written 
It does not admit comments

## Validations
The program will check the following aspects:
- [x] The xml file follows the structure of the template
- [x] No tag can be null except for the 'incidencies' one
- [x] totalLaps must be an integer of 1-3 digits
- [x] driverNum must be an integer of 1-3 digits
- [x] driverName and circuit can only contain letters. Length has to be less than 80 chars. Names with ' in them should be written without it (Pato O'Ward -> Pato OWard)
- [x] the total number of 'lap' registers inside 'laps' must be equal to totalLaps (except if there's an incidency such as DSQ, DNF or Lapped)
- [x] lapNumber should never be higher than totalLaps, and should be increasing by 1 for each register
- [x] incidencies can only accept 7 different values
	- [x] RedFlag
	- [x] YellowFlag
	- [x] TrackLimits (this lap's times will not be taken into account for the quickest sector or lap)
	- [x] DSQ, DNF, Lapped (the program will end there and print the expected values)
	- [x] PitStop (checks that there werent used more than 3 different compounds, excluding full wet and intermediates)
- [x] tyres can only be C1-5, Full Wet (FW) and Intermediate (IM), and there cannot be more than 3 standard compounds in a single race
- [x] tyrelife must increase by one, except if there is a pitstop
- [x] the sum of all sectors must be equal to lapTime
- [x] For multiple reasons, there may be times that a sector has no time (NoTime), in which cases, the total of the sectors will not be sumed

## Output
```
-----------
 Circuit: Suzuka 
 Laps: 53
 Driver: Fernando Alonso | 14

Fastest sector 1 : 00:33.924 in lap 53 with C1 tyres on 19 laps
Fastest sector 2 : 00:42.332 in lap 53 with C1 tyres on 19 laps
Fastest sector 3 : 00:18.279 in lap 36 with C1 tyres on 02 laps
Fastest lap      : 01:34.726 in lap 53 with C1 tyres on 19 laps
```

or
```
-----------
 Circuit: Suzuka 
 Laps: 53
 Completed laps: 1 (DNF)
 Driver: Alex Albon | 23

Fastest sector 1 : 00:51.043 in lap 01 with C2 tyres on 00 laps
Fastest sector 2 : 01:09.943 in lap 01 with C2 tyres on 00 laps
No time found for any sector 3
No time found for any lap
```

## Compiling/running/testing
A Makefile and a folder 'testFiles' are given to simplify it

`make compile` compiles all the modules and generates the executable called 'F1TimeCheck'

`make all` compiles the modules and executes the program with the 3 correct xml files

`make test` compiles the modules and executes the program with the 15 different test files
