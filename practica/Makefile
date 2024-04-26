FUENTE = F1TimeCheck
FOLDER = testFiles/
ALONSO = $(FOLDER)Suzuka-ALO14.xml
SAINZ = $(FOLDER)Suzuka-SAI55.xml
ALBON = $(FOLDER)Suzuka-ALB23.xml
ERRORS = $(FOLDER)errorStructure.xml
ERRORNT1 = $(FOLDER)errorNullTag1.xml
ERRORNT2 = $(FOLDER)errorNullTag2.xml
ERRORNT3 = $(FOLDER)errorNullTag3.xml
ERRORNT4 = $(FOLDER)errorNullTag4.xml
ERRORNT5 = $(FOLDER)errorNullTag5.xml
ERROROOB1 = $(FOLDER)errorOutOfBoundsNum.xml
ERROROOB2 = $(FOLDER)errorOutOfBoundsNum2.xml
ERRORML = $(FOLDER)errorMoreLaps.xml
ERRORLL = $(FOLDER)errorLessLaps.xml
ERRORWI = $(FOLDER)errorWrongIncidency.xml
ERRORWT = $(FOLDER)errorWrongTyre.xml
ERRORMT = $(FOLDER)errorMoreTyres.xml
ERRORNPS = $(FOLDER)errorNoPitStop.xml
ERRORWS = $(FOLDER)errorWrongSectors.xml
ERRORNTM = $(FOLDER)errorNoTimes.xml
ERRORNTMP = $(FOLDER)errorNoTimesPartial.xml
TRACKLIMITS = $(FOLDER)trackLimitsTest.xml
LIB = lfl

all: compile alo sai alb

test: compile errors errornt1 errornt2 errornt3 errornt4 errornt5 erroroob1 erroroob2 errorml errorll errorwi errorwt errormt errornps errorws errorntm errorntmp tracklimits

compile:
		@flex $(FUENTE).l
		@bison -o $(FUENTE).tab.c $(FUENTE).y -yd --debug
		@gcc -o $(FUENTE) lex.yy.c $(FUENTE).tab.c -$(LIB) -ly

alo:
	@./$(FUENTE) $(ALONSO)

sai:
	@./$(FUENTE) $(SAINZ)

alb:
	@./$(FUENTE) $(ALBON)

errors:
	@echo "\033[95m - TEST 1\n    Structural error test:\033[0m"
	@./$(FUENTE) $(ERRORS)
errornt1:
	@echo "\033[95m - TEST 2\n    Null value in tag 'driverNum' error test:\033[0m"
	@./$(FUENTE) $(ERRORNT1)
errornt2:
	@echo "\033[95m - TEST 3\n    Null value in tag 'circuit' error test:\033[0m"
	@./$(FUENTE) $(ERRORNT2)
errornt3:
	@echo "\033[95m - TEST 4\n    Null value in tag 'driverName' error test:\033[0m"
	@./$(FUENTE) $(ERRORNT3)
errornt4:
	@echo "\033[95m - TEST 5\n    Null value in tag 'lapNumber' error test:\033[0m"
	@./$(FUENTE) $(ERRORNT4)
errornt5:
	@echo "\033[95m - TEST 6\n    Null value in tag 'tyre' error test:\033[0m"
	@./$(FUENTE) $(ERRORNT5)
erroroob1:
	@echo "\033[95m - TEST 5\n    Invalid value for 'driverNum' error test:\033[0m"
	@./$(FUENTE) $(ERROROOB1)
erroroob2:
	@echo "\033[95m - TEST 6\n    Invalid value for 'totalLaps' error test:\033[0m"
	@./$(FUENTE) $(ERROROOB2)
errorml:
	@echo "\033[95m - TEST 7\n    More laps than 'totalLaps' error test:\033[0m"
	@./$(FUENTE) $(ERRORML)
errorll:
	@echo "\033[95m - TEST 8\n    Less laps than 'totalLaps' error test:\033[0m"
	@./$(FUENTE) $(ERRORLL)
errorwi:
	@echo "\033[95m - TEST 9\n    Wrong value for 'incidency' error test:\033[0m"
	@./$(FUENTE) $(ERRORWI)
errorwt:
	@echo "\033[95m - TEST 10\n    Wrong value for 'tyre' error test:\033[0m"
	@./$(FUENTE) $(ERRORWT)
errormt:
	@echo "\033[95m - TEST 11\n    More than 3 different tyres excluding FW and IM error test:\033[0m"
	@./$(FUENTE) $(ERRORMT)
errornps:
	@echo "\033[95m - TEST 12\n    Tyre change without pitstop error test:\033[0m"
	@./$(FUENTE) $(ERRORNPS)
errorws:
	@echo "\033[95m - TEST 13\n    Sectors times doesnt ammount to 'laptime' error test:\033[0m"
	@./$(FUENTE) $(ERRORWS)
errorntm:
	@echo "\033[95m - TEST 14\n    No times error test:\033[0m"
	@./$(FUENTE) $(ERRORNTM)
errorntmp:
	@echo "\033[95m - TEST 15\n    No times for sector 1 error test:\033[0m"
	@./$(FUENTE) $(ERRORNTMP)
tracklimits:
	@echo "\033[95m - TEST 16\n    Track limits invalidates lap time test:\033[0m"
	@./$(FUENTE) $(TRACKLIMITS)




clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h