package cmd

import (
	find "github.com/infraflakes/srn-find/pkg"
	"github.com/spf13/cobra"
)

var RootCmd = &cobra.Command{
	Use:   "find",
	Short: "Search for words, files, or directories",
}

func Execute() error {
	return RootCmd.Execute()
}

func init() {
	RootCmd.AddCommand(find.WordCmd)
	RootCmd.AddCommand(find.FileCmd)
	RootCmd.AddCommand(find.DirCmd)
}
