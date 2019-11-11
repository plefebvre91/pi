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
# Check for at least 1 parameter
#######################################
if [ -z $1 ]
then
    usage
    exit
fi


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
    echo "Usage: pi.bash <project_name>"
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


read -p "Project's author: " author

project_name=$1
current_directory=`pwd`

echo "[+] Copying template..."
cp -R template/sfml $current_directory/$project_name


cd $project_name

echo "[+] Creating CPP files..." 
echo "  [*] Moving project.cpp to $project_name.cpp..." 
mv src/project.cpp src/$project_name.cpp

readonly cpp_files=`find src -name "*.cpp"`
for file in $cpp_files
do
    replace_in_file "{{project}}" $project_name $file
done


echo "[+] Creating HPP files..." 

echo "  [*] Moving project.hpp to $project_name.hpp..." 
mv include/project.hpp include/"$project_name.hpp" 

readonly hpp_files=`find include -name "*.hpp"`
for file in $hpp_files
do
    replace_in_file "{{project}}" $project_name $file
done



echo "[+] Creating CMakeLists.txt..."
replace_in_file "{{project}}" $project_name CMakeLists.txt

echo "[+] Done"
