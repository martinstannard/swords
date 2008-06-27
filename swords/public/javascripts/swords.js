function fadeUp (element, red, green, blue)
{
	if (element.fade) 
	{
		clearTimeout(element.fade);
	}
	element.style.backgroundColor = "rgb("+red+","+green+","+blue+")";
	if ((red == 255) && (green == 255) && (blue == 255)) 
	{
		return;
	}
	var newred = red + Math.ceil((255 - red)/10);
	var newgreen = green + Math.ceil((255 - green)/10);
	var newblue = blue + Math.ceil((255 - blue)/10);
	var repeat = function() 
	{
		fadeUp(element, newred, newgreen, newblue);
	};
	element.fade = setTimeout(repeat, 100);
}

function addLoadEvent (func) 
{
	var oldonload = window.onload;
	if (typeof window.onload != 'function') 
	{
		window.onload = func;
	}
	else 
	{
		window.onload = function() 
		{
			oldonload();
			func();
		}
	}
}

function initialiseSword ()
{
	if (!document.getElementsByTagName || !document.getElementById) 
	{
		return false;
	}
	if (!document.getElementById('crossword')) 
	{
		return false;
	}
	var sword = document.getElementById('crossword');
	var cells = sword.getElementsByTagName('td');
	for (var i=0; i < cells.length; i++) 
	{
		if (cells[i].className != 'inactive') 
		{
			cells[i].onclick = selectCell;
		}
	}
}

function inspectSwordGrid (sword, grid)
{
	// Get Sword's dimensions
	var rows = sword.getElementsByTagName('tr');
	var height = rows.length;
	var width = rows[0].getElementsByTagName('td').length;
	var swordGrid = [];
	for (var i=0; i < grid.length; i++) 
	{
		var x_pos = grid[i][0][0];
		var y_pos = grid[i][0][1];
		var char = grid[i][1];
		swordGrid[x_pos+''+y_pos] = char;
	}
	return swordGrid;
}

function findCellValue (swordGrid, cell)
{
	var x_pos = cell.className;
	var y_pos = cell.parentNode.className;
	return swordGrid[x_pos+''+y_pos];
}

function selectCell (cell)
{
	if (this.nodeName == 'TD') 
	{
		var cell = this;
	}
	else
	{
		var cell = cell;
	}
	// WHY is it losing focus when there is no value? This only applies to keyboard navigation.
	var value = '';
	// Is there any existing user input?
	if (cell.getElementsByTagName('span').length > 0) 
	{
		var spans = cell.getElementsByTagName('span');
		// Save its value
		var existing_input = spans[0];	// There *should* be only one
		value = existing_input.firstChild.nodeValue;
		for (var i=0; i < spans.length; i++) 
		{
			cell.removeChild(spans[i]);
		}
	}
	// Create the input
	var input = document.createElement('input');
	input.setAttribute('maxlength', '1');
	input.setAttribute('value', value);
	input.onkeypress = saveUserInputAndMove;
	input.onblur = saveUserInput;
	cell.appendChild(input);
	input.focus();
}

function saveUserInput ()
{
	// Save input value when it's done
	var value = document.createTextNode(this.value);
	var user_input = document.createElement('span');
	user_input.appendChild(value);
	this.parentNode.replaceChild(user_input, this);
	crosswordIsDone();
}

function saveUserInputAndMove (event)
{
	var key = event.keyCode;
	if (key > 36 && key < 41) 
	{
		// Save the user input
		var cell = this.parentNode;
		var value = document.createTextNode(this.value);
		var user_input = document.createElement('span');
		user_input.appendChild(value);
		cell.replaceChild(user_input, this);
		crosswordIsDone();
		// Handle the direction arrows when pressed
		var left = 37;
		var up = 38;
		var right = 39;
		var down = 40;
		// Get rows
		var rows = document.getElementById('crossword').getElementsByTagName('tr');
		switch(event.keyCode) {
			case left:
				var leftCell = cell.previousSibling.previousSibling;
				if (leftCell && leftCell.className != 'inactive') 
				{
					selectCell(leftCell);		
				}	
				else
				{
					selectCell(cell);
				}
				break;
			case right:  
				var rightCell = cell.nextSibling.nextSibling;
				if (rightCell && rightCell.className != 'inactive') 
				{
					selectCell(rightCell);
				}	
				else
				{
					selectCell(cell);
				}
				break;
			case up:
				var y = cell.parentNode.className;
				y--;
				if (y >= 0) 
				{
					var aboveCell = rows[y].getElementsByTagName('td')[cell.className];
					if (aboveCell && aboveCell.className != 'inactive') 
					{
						selectCell(aboveCell);
					}
					else
					{
						selectCell(cell);
					}
				}
				break;
			case down:  
				var y = cell.parentNode.className;
				y++;
				if (y < rows.length) 
				{
					var belowCell = rows[y].getElementsByTagName('td')[cell.className];
					if (belowCell && belowCell.className != 'inactive') 
					{
						selectCell(belowCell);
					}
					else
					{
						selectCell(cell);
					}
				}
				break;
	    }
		return false;
	}
};

function crosswordIsDone ()
{
	if (!document.getElementsByTagName || !document.getElementById) 
	{
		return false;
	}
	if (!document.getElementById('crossword')) 
	{
		return false;
	}
	var sword = document.getElementById('crossword');
	var cells = sword.getElementsByTagName('td');
	var complete = true;
	var swordGrid = inspectSwordGrid(sword, grid);
	for (var i=0; i < cells.length; i++) 
	{
		if (cells[i].className != 'inactive') 
		{
			// Find out what letter should be here by the cell's coords
			cellValue = findCellValue(swordGrid, cells[i]);
			var spans = cells[i].getElementsByTagName('span');
			if (spans.length > 0) 
			{
				// To do: check if saved user input is the correct letter, if it isn't set complete to false
				var user_input = spans[0].firstChild.nodeValue;
				if (user_input != cellValue) 
				{
					complete = false;
				}
			}
			else
			{
				complete = false;
			}
		}
	}
	if (complete) 
	{
		displayCongrats();
	}
}

function displayCongrats ()
{
	var title = "Sword complete!";
	var msg = "Hey, nice one! Swords is pretty intense, and this means that you are amazing because you completed a Sword. Good work!";
	var congrats = document.createElement('div');
	var h2 = document.createElement('h2');
	var copy = document.createElement('p');
	var title = document.createTextNode(title);
	var msg = document.createTextNode(msg);
	h2.appendChild(title);
	copy.appendChild(msg);
	congrats.appendChild(h2);
	congrats.appendChild(copy);
	document.getElementById('primary').appendChild(congrats);	
	fadeUp(congrats, 204, 255, 102);
}

addLoadEvent(initialiseSword);