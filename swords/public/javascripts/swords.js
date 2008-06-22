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

function initialiseSword (grid)
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
	
	
}

function findCell (grid, cell)
{
	// Here we are past a td element which is within the crossword table
	// What do we want?
	// 	- The column number
	// 	- The row number
	//	- What should exist there
	// What do we have?
	// 	- grid is an array of cells, containing their coords and value
	// 	We need to find the coords (col, row) and the corresponding value in the grid variable
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
	// crosswordIsFull(grid);
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

function crosswordIsFull (grid)
{
	if (!document.getElementsByTagName || !document.getElementById) 
	{
		return false;
	}
	if (!document.getElementById('crossword')) 
	{
		return false;
	}
	var crossword = document.getElementById('crossword');
	var cells = crossword.getElementsByTagName('td');
	var complete = true;
	for (var i=0; i < cells.length; i++) 
	{
		if (cells[i].className != 'inactive') 
		{
			// Find out what letter should be here by the cell's coords
			cell = findCell(grid, cells[i]);
			var spans = cells[i].getElementsByTagName('span');
			if (spans.length > 0) 
			{
				// To do: check if saved user input is the correct letter, if it isn't set complete to false
				var user_input = spans[0].firstChild.nodeValue;
				if (user_input != cell['properValue']) 
				{
					complete = false;
				}
			}
		}
	}
	if (complete) 
	{
		alert("Congratulations!!! You are allowed to upload an instant Duke hit");
	}
}

addLoadEvent(initialiseSword);