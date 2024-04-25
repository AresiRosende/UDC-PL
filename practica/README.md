# F1 Timing Flex/Bison Analyzer

This program was made using both Flex and Bison.
The goal of it is to analyze a given xml file containing the timing on each lap of a driver and check if the values are valid. If they are, it will return the laps in which the driver made the fastests sectors and lap and the compound they were using

## TODO
[ ] La funcion para sumar los tiempos
[ ] No reconoce bien los arrays de tiempo y de compuestos
[ ] Guarda mal la vuelta en la que suceden las cosas

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
- [ ] the sum of all sectors must be equal to lapTime
- [x] For multiple reasons, there may be times that a sector has no time (NoTime), in which cases, the total of the sectors will not be sumed

## Output
Once a file has been validated, the program will return
```
Driver 'Aaaa Bbbbb' 00
Ended race on lap C (reason: D) /*in case of DSQ, DNF or Lapped*/ 
Fastest sector 1 : tt:tt.ttt in lap X with tyres Y on Z laps
Fastest sector 2 : tt:tt.ttt in lap X with tyres Y on Z laps
Fastest sector 3 : tt:tt.ttt in lap X with tyres Y on Z laps
Fastest lap : tt:tt.ttt in lap X with tyres Y on Z laps
```

## Compiling/running
A Makefile is given to simplify this process. 

`make compile` compiles all the modules and generates an executable called 'F1TimeCheck'

`make all` compiles the modules and executes the program with the 2 example xml files
