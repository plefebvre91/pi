/* MIT License

Copyright (c) 2019 {{AUTHOR}}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. */

#include "{{project}}.hpp"
#include "constants.hpp"


{{project}}::{{project}}()
{
  window = new
    sf::RenderWindow(sf::VideoMode({{PROJECT}}_WINDOW_SIZE, {{PROJECT}}_WINDOW_SIZE), {{PROJECT}}_APP_TITLE);
  window->setVerticalSyncEnabled(true);
}
  
void {{project}}::run()
{
  // Start the game loop
  while (window->isOpen())
  {
    // Process events
    sf::Event event;
    while (window->pollEvent(event))
      {
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::Escape))
	  window->close();
      
	if (event.type == sf::Event::Closed)
	  window->close();
    }
    
    window->clear();

    // DRAW THINGS HERE
    
    window->display();
  }
}

{{project}}::~{{project}}()
{
  delete window;
}
