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

function editCell ()
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
					// Delete all spans to ensure things don't go awry. There should only be one, and we're assuming that above but I had an issue with extra spans and inputs being appended and didn't resolve it properly
					for (var i=0; i < spans.length; i++) 
					{
						this.removeChild(spans[i]);
					}
				}
				// Create the input
				var input = document.createElement('input');
				input.setAttribute('maxlength', '1');
				input.setAttribute('value', value);
				input.onblur = function ()
				{
					// Save input value when it's done
					var value = document.createTextNode(this.value);
					var user_input = document.createElement('span');
					user_input.appendChild(value);
					this.parentNode.replaceChild(user_input, this);
					crosswordIsFull();
				}
				this.appendChild(input);
				input.focus();
			}
		}
	}
}

function crosswordIsFull ()
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
			if (cells[i].getElementsByTagName('span').length == 0) 
			{
				complete = false;
			}
		}
	}
	if (complete) 
	{
		alert('You have filled it in');
	}
}

addLoadEvent(editCell);