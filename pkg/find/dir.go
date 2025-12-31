package find

import (
	"github.com/spf13/cobra"
	"github.com/infraflakes/srn-libs/cli"
)

var DirCmd = cli.NewCommand(
	"dir <path> <terms...>",
	"Search for directories by name",
	cobra.MinimumNArgs(2),
	func(cmd *cobra.Command, args []string) {
		path := args[0]
		terms := args[1:]
		FindAndProcess(path, terms, "d", "Searching for directories with '%s' in %s\n", "Delete matched directories? (y/N): ", false)
	},
)

var DirDeleteCmd = cli.NewCommand(
	"delete <path> <terms...>",
	"Delete directories by name",
	cobra.MinimumNArgs(2),
	func(cmd *cobra.Command, args []string) {
		path := args[0]
		terms := args[1:]
		FindAndProcess(path, terms, "d", "Searching for directories with '%s' in %s\n", "Delete matched directories? (y/N): ", true)
	},
)

func init() {
	DirCmd.AddCommand(DirDeleteCmd)
}
