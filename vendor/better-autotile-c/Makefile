CC      = gcc
CFLAGS  = -Wall -Wextra -O2 -std=c11
TARGET  = better_autotile

PREFIX ?= /usr/local
BINDIR  = $(DESTDIR)$(PREFIX)/bin

all: $(TARGET)

$(TARGET): main.c vendor/cJSON.c
	$(CC) $(CFLAGS) -o $@ $^

install: $(TARGET)
	install -Dm755 $(TARGET) $(BINDIR)/$(TARGET)

uninstall:
	rm -f $(BINDIR)/$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all install uninstall clean
