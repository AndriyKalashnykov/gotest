package cmd

import (
	"encoding/json"
	"fmt"

	"github.com/AndriyKalashnykov/gotest/internal/structtag"
	"github.com/spf13/cobra"
)

// Transaction and Account are sample structs used to demonstrate
// reflection-based struct-tag grouping. Their fields are read via reflection
// (by struct.tag), not directly, so they are exported to document the example.
type Transaction struct {
	Name *string `validate:"required"`
}

// Account is the sample struct the `fields` command inspects.
type Account struct {
	Address          *string       `validate:"required"`
	NetworkID        *uint         `validate:"required"`
	NodeID           *uint         `validate:"optional"`
	PoolID           *uint         `validate:"optional"`
	ToTransactions   []Transaction `validate:"optional,association"`
	FromTransactions []Transaction `validate:"optional,association"`
}

var fieldsTag string

var fieldsCmd = &cobra.Command{
	Use:   "fields",
	Short: "Group a sample struct's fields by a struct tag",
	Long: "fields demonstrates reflection-based struct-tag parsing: it groups the\n" +
		"fields of a sample Account struct by the value of the chosen tag\n" +
		"(default \"validate\") and prints the result as JSON.",
	RunE: func(cmd *cobra.Command, _ []string) error {
		groups, err := structtag.GroupFieldsByTag(Account{}, fieldsTag)
		if err != nil {
			return err
		}
		out, err := json.MarshalIndent(groups, "", "  ")
		if err != nil {
			return err
		}
		fmt.Fprintln(cmd.OutOrStdout(), string(out))
		return nil
	},
}

func init() {
	fieldsCmd.Flags().StringVarP(&fieldsTag, "tag", "t", "validate", "struct tag to group fields by")
	RootCmd.AddCommand(fieldsCmd)
}
