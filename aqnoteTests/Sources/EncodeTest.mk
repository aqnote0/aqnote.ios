
CLASS				=	EncodeTest
OJBS				=	EnCodeTest.o
PROGRAM 		= EncodeTest.out

#FWPATH = $(xcode-select --print-path)/Library/Frameworks
FWPATH = /Applications/Xcode.app/Contents/Developer/Library/Frameworks

#XCTEST = $(xcrun --find xctest)
XCTEST = /Applications/Xcode.app/Contents/Developer/usr/bin/xctest

#CC = gcc ## clang # or gcc

CFLAGS = -Wall -F$(FWPATH)
LDFLAGS = -F$(FWPATH) -framework Foundation -framework XCTest

$(PROGRAM): $(OBJS)
		$(CC) $(OBJS) $(LDFLAGS) -o $(PROGRAM)

test: $(PROGRAM)
	DYLD_FRAMEWORK_PATH=$(FWPATH) 
	$(XCTEST) -XCTest $(CLASS) $(POGRAM)

clean:
	$(RM) -rf $(PROGRAM) *.o

$(OBJS): 
	$(CC) -c $(OBJS) $(CLASS).m
