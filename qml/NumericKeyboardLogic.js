var curVal = 0
var memory = 0
var lastOp = ""
var previousOperator = ""
function digitPressed(op)
{
    if (disabled(op))
        return
    if (display.getText().length >= display.maxDigits)
        return
    if (lastOp.toString().length == 1 && ((lastOp >= "0" && lastOp <= "9") || lastOp == ".") ) {
        display.appendDigit(op.toString())
    } else {
        display.appendDigit(op.toString())
    }
    if(op === ".")
        dotkey.dimmed = true
    if(display.getText().length > 1 || (display.getText().length === 1 && display.getText().search(/\./) === -1))
        submitkey.dimmed = false;
    lastOp = op
}
function disabled(op) {
    if (op==="X")
        return false
    if (op==="C")
        return false

    else if(op === "√" && (display.getText().length === 0 || (display.getText().length === 1 && display.getText().search(/\./) !== -1))) {
        return true
    }
    else if(display.getText().length !== 0 && op === "-")
        return true;
    else if (display.getText() === "" && !((op >= "0" && op <= "9")) && op !== "-")
        return true
    else if (op === "." && display.getText().search(/\./) !== -1) {
        return true
    } else if (op === "0" &&  display.getText().length === 1 && display.getText() === "0") {
        return true
    } else {
        return false
    }
}
function operatorPressed(op)
{
    console.log("WTF0" + op)

    if (disabled(op))
        return
    lastOp = op
    if(op.toString() === "✔") {
        display.submit()
    }
    if (op === "X") {
        display.clear()
        display.cancel()
    }
    console.log("WTF1")

    // Reset the state on 'C' operator or after
    // an error occurred
    if (op === "C") {
        display.removeLast()
        if(display.getText().search(/\./) === -1)
            dotkey.dimmed = false
        if(display.getText().length > 1 || (display.getText().length === 1 && display.getText().search(/\./) === -1))
            submitkey.dimmed = false;
        else
            submitkey.dimmed = true;
    }
    if(op === "√")
        display.submit()
}
