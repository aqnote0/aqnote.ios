CC = gcc # clang # or gcc

FRAMEWORKS := #-framework Foundation 
LIBRARIES := #-lobjc
LDFLAGS = $(LIBRARIES) $(FRAMEWORKS)

SOURCE = Signal.c
CFLAGS = -g $(SOURCE)

OUT = -o Signal 

all:
	$(CC) $(CFLAGS) $(LDFLAGS) $(OUT)

