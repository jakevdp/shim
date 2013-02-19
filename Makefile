X := $(shell which scidb)
X := $(shell dirname ${X})
SCIDB := $(shell dirname ${X})

CFLAGS=-fopenmp
INC=-I. -DPROJECT_ROOT="\"$(SCIDB)\"" -I"$(SCIDB)/include" -DSCIDB_CLIENT
LIBS=-ldl -lpthread -L"$(SCIDB)/lib" -lscidbclient -lboost_system

shim:
	$(CXX) $(INC) -fpic -g -c client.cpp -o client.o
	$(CC) -Wall $(CFLAGS) $(INC) -o shim shim.c mongoose.c client.o $(LIBS)

install:
	cp shim "$(SCIDB)/bin"
	mkdir -p /var/lib/shim
	cp -aR wwwroot /var/lib/shim/
	chmod -R 755 /var/lib/shim

uninstall:
	rm -f "$(SCIDB)/bin/shim"
	rm -rf /var/lib/shim

clean:
	rm -f *.o *.so shim
