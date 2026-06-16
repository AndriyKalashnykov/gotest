// Package calc provides small integer arithmetic helpers. It exists mainly to
// demonstrate table-driven testing in this playground.
package calc

import "errors"

// ErrDivideByZero is returned by Divide when the divisor is zero.
var ErrDivideByZero = errors.New("calc: division by zero")

// Add returns the sum of x and y.
func Add(x, y int) int { return x + y }

// Subtract returns the difference x - y.
func Subtract(x, y int) int { return x - y }

// Multiply returns the product of x and y.
func Multiply(x, y int) int { return x * y }

// Divide returns the integer quotient x / y. It returns ErrDivideByZero when y
// is zero. Division truncates toward zero, matching Go's `/` operator.
func Divide(x, y int) (int, error) {
	if y == 0 {
		return 0, ErrDivideByZero
	}
	return x / y, nil
}
