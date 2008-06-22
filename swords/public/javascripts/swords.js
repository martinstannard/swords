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

function editCell (grid)
{
	if (!document.getElementsByTagName || !document.getElementById) 
	{
		return false;
	}
	var crossword = document.getElementById('crossword');
	var cells = crossword.getElementsByTagName('td');
	for (var i=0; i < cells.length; i++) 
	{
		if (cells[i].className != 'inactive') 
		{
			cells[i].onclick = function ()
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
				input.onkeypress = function(event) 
				{
					// event.keyCode
				};
				input.onblur = function ()
				{
					// Save input value when it's done
					var value = document.createTextNode(this.value);
					var user_input = document.createElement('span');
					user_input.appendChild(value);
					this.parentNode.replaceChild(user_input, this);
					// crosswordIsFull(grid);
				}
				this.appendChild(input);
				input.focus();
			}
		}
	}
}

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
			var spans = cells[i].getElementsByTagName('span');
			if (spans.length > 0) 
			{
				
			}
		}
	}
	if (complete) 
	{
		alert("Congratulations!!! You have filled it in, but we can't tell you if it's right yet...");
	}
}

addLoadEvent(editCell);