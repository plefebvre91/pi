#!/bin/bash

# MIT License
# 
# Copyright (c) 2019 Pierre Lefebvre
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#######################################
# Help function
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
usage()
{
    echo "Usage: pi.bash <type> <project_name>"
    echo "  - type can be: 'sfml', 'cpp'"
}


#######################################
# Returns the calling string value
# converted to uppercase.
# Globals:
#   None
# Arguments:
#   str - String to uppercase
# Returns:
#   Uppercased string
#######################################
to_uppercase()
{
    local str=$1
    echo $str | tr a-z A-Z
}


#######################################
# Replaces all occurences of src by
# dest in file (lowercase and uppercase
# versions of src and dst)
# Globals:
#   $author
# Arguments:
#   src - String to replace (lowercase)
#   dst - Replacing string (lowercase)
#   file - File to update
# Returns:
#   None
#######################################
replace_in_file()
{
    local src=$1
    local dst=$2
    local file=$3
    local src_uppercase=$(to_uppercase $src)
    local dst_uppercase=$(to_uppercase $dst)
    
    sed -i "s/$src/$dst/g" $file
    sed -i "s/$src_uppercase/$dst_uppercase/g" $file
    sed -i "s/{{AUTHOR}}/$author/g" $file
}


#######################################
# Replaces all occurences of src by
# dest in file (lowercase and uppercase
# versions of src and dst)
# Globals:
#   $author
# Arguments:
#   src - String to replace (lowercase)
#   dst - Replacing string (lowercase)
#   file - File to update
# Returns:
#   None
#######################################
check_dependecies()
{
    local deps="cmake"

    for dep in $deps
    do
	echo -n "Checking for $dep..."
	command -v $dep >/dev/null 2>&1 || { echo >&2 "Require $dep but it's not installed.  Aborting."; exit; }
	echo " [OK]"
    done
}


#######################################
# Check for dependencies
#######################################
check_dependecies


#######################################
# Check for at least 2 parameters
#######################################
if [ -z $2 ]
then
    usage
    exit
fi


template_style=$1
project_name=$2

#######################################
# Get author name
#######################################
read -p "Project's author: " author


echo "[+] Copying $template_style template..."
cp -R template/$template_style $project_name

cd $project_name


#######################################
# Source files
#######################################
echo "  [*] Moving project.cpp to $project_name.cpp..." 
mv src/project.cpp src/$project_name.cpp

echo "[+] Creating CPP files..." 
readonly cpp_files=`find src -name "*.cpp"`
for file in $cpp_files
do
    replace_in_file "{{project}}" $project_name $file
done


#######################################
# Header files
#######################################
echo "  [*] Moving project.hpp to $project_name.hpp..." 
mv include/project.hpp include/"$project_name.hpp" 

echo "[+] Creating HPP files..." 
readonly hpp_files=`find include -name "*.hpp"`
for file in $hpp_files
do
    replace_in_file "{{project}}" $project_name $file
done


#######################################
# Toolchain files
#######################################
echo "[+] Creating CMakeLists.txt..."
replace_in_file "{{project}}" $project_name CMakeLists.txt

echo "[+] Done"
