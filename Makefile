############################################################################
# Copyright 2009 Tomer Shiri github@shiri.info                             #
#                                                                          #
# Licensed under the Apache License, Version 2.0 (the "License");          #
# you may not use this file except in compliance with the License.         #
# You may obtain a copy of the License at                                  #
#                                                                          #
# http://www.apache.org/licenses/LICENSE-2.0                               #
#                                                                          #
# Unless required by applicable law or agreed to in writing, software      #
# distributed under the License is distributed on an "AS IS" BASIS,        #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
# See the License for the specific language governing permissions and      #
# limitations under the License.                                           #
############################################################################

############################################################################
# Instructions:                                                            #
# Put this makefile in the main project's directory. (./)                  #
# It will compile and link every cpp file in that directory                # 
# and in all of its subdirectories. (recursively)                          #
# Header files will be added to the build path automatically.              #
# Enjoy.                                                                   #
############################################################################

##=====================================================================================##
## Customizable Section: change these variables to suit your program.                  ##
##=====================================================================================##

# Which flags should I use?
FLAGS = -std=c++11
# What is the name of the executable file?
EXENAME = run
# Where should I put all the compiled .o files? (add a slash at the end)
TARGET = target/

##=====================================================================================##
## Optional Section: If you'll leave it blank, I'll search for your .h and .cpp files. ##
##=====================================================================================##

# Where are the header files? (add a slash at the end, Separate dirs with a whitespace)
HEADERS =
# What are the file names? (Use paths from basedir. Separate filenames with a whitespace) 
FILES =
# Should I exclude some files from the build? (same rules apply)
EXCLUDE =

##=====================================================================================##
## Don't edit below this line, you know its bad for you.                               ##
##=====================================================================================##

SHELL = /bin/sh
DIRS = $(patsubst %:, %, $(shell ls -B -R -F ./ | grep ^./))
DIRS := $(DIRS) .
HEADERS := $(HEADERS) $(strip $(foreach dir, $(DIRS), $(patsubst %, $(dir),$(firstword $(wildcard $(dir)/*.h)))))

ifndef FILES
  FILES = $(patsubst .//%, ./%, $(foreach dir, $(DIRS), $(wildcard $(dir)/*.cpp)))
endif

ifndef EXCLUDE
  FILELIST = $(FILES)
else
  FILELIST = $(foreach filename, $(EXCLUDE),$(filter-out ./$(filename), $(FILES)))
endif

all: init clean mkdir link end
init:
	$(info * [Starting build])
	$(info * [found header at:$(HEADERS)])
	$(info * [found cpp files:$(FILELIST)])
clean:
	$(info * [Cleaning old build])
	$(RM) -r -f $(addprefix $(TARGET), $(filter-out ./, $(dir $(FILELIST))))
mkdir:
	$(info * [Creating target directories])
	mkdir -p $(TARGET) $(addprefix $(TARGET), $(filter-out ./, $(dir $(FILELIST))))
link:	$(patsubst %.cpp, %.o, $(FILELIST))
	$(info * [Linking])
	$(CXX) -o $(EXENAME) $(addprefix $(TARGET), $^) $(CXXFLAGS) $(FLAGS) $(addprefix -I,$(HEADERS))
#compile
%.o : %.cpp
	$(info * [Creating $(TARGET)$@ from $<])
	$(CXX) -c $(CXXFLAGS) $(FLAGS) $< -o $(TARGET)$@ $(addprefix -I,$(HEADERS))
end:
	$(info * [Build successful. $(EXENAME) was created])
.PHONY: all init clean mkdir link end
.PRECIOUS: link %.o
.SILENT:
#FIN