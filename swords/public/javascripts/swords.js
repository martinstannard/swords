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
			cells[i].onclick = editCell;
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

function editCell ()
{
	var value = '';
	// Is there any existing user input?
	if (this.getElementsByTagName('span').length > 0) 
	{
		var spans = this.getElementsByTagName('span');
		// Save its value
		var existing_input = spans[0];	// There *should* be only one
		value = existing_input.firstChild.nodeValue;
		for (var i=0; i < spans.length; i++) 
		{
			this.removeChild(spans[i]);
		}
	}
	// Create the input
	var input = document.createElement('input');
	input.setAttribute('maxlength', '1');
	input.setAttribute('value', value);
	// input.onkeypress = saveUserInputAndMove;
	input.onblur = saveUserInput;
	this.appendChild(input);
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
	// Handle the direction arrows when pressed
	var left = 37;
	var up = 38;
	var right = 39;
	var down = 40;
	switch(event.keyCode) {
		case left:
		break;
		case up:
		break;
		case right:  
		break;
		case down:  
		break;
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