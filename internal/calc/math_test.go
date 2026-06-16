package calc

import (
	"errors"
	"testing"
)

func TestAdd(t *testing.T) {
	tests := []struct {
		name string
		x, y int
		want int
	}{
		{"positives", 4, 6, 10},
		{"with negative", -4, 6, 2},
		{"both negative", -4, -6, -10},
		{"zeros", 0, 0, 0},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := Add(tt.x, tt.y); got != tt.want {
				t.Errorf("Add(%d, %d) = %d, want %d", tt.x, tt.y, got, tt.want)
			}
		})
	}
}

func TestSubtract(t *testing.T) {
	tests := []struct {
		name string
		x, y int
		want int
	}{
		{"positive result", 6, 4, 2},
		{"negative result", 4, 6, -2},
		{"identity", 5, 0, 5},
		{"to zero", 7, 7, 0},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := Subtract(tt.x, tt.y); got != tt.want {
				t.Errorf("Subtract(%d, %d) = %d, want %d", tt.x, tt.y, got, tt.want)
			}
		})
	}
}

func TestMultiply(t *testing.T) {
	tests := []struct {
		name string
		x, y int
		want int
	}{
		{"positives", 4, 6, 24},
		{"by zero", 5, 0, 0},
		{"sign flip", -4, 6, -24},
		{"two negatives", -4, -6, 24},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := Multiply(tt.x, tt.y); got != tt.want {
				t.Errorf("Multiply(%d, %d) = %d, want %d", tt.x, tt.y, got, tt.want)
			}
		})
	}
}

func TestDivide(t *testing.T) {
	tests := []struct {
		name    string
		x, y    int
		want    int
		wantErr error
	}{
		{"exact", 6, 2, 3, nil},
		{"truncates toward zero", 7, 2, 3, nil},
		{"negative dividend truncates toward zero", -7, 2, -3, nil},
		{"by zero", 1, 0, 0, ErrDivideByZero},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := Divide(tt.x, tt.y)
			if !errors.Is(err, tt.wantErr) {
				t.Fatalf("Divide(%d, %d) error = %v, want %v", tt.x, tt.y, err, tt.wantErr)
			}
			if got != tt.want {
				t.Errorf("Divide(%d, %d) = %d, want %d", tt.x, tt.y, got, tt.want)
			}
		})
	}
}
