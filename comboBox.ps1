function Show-ComboBox {
    [CmdLetBinding()]
    Param (
        [Parameter(Mandatory=$true)] $Items,
        [Parameter(Mandatory=$false)] [switch] $ReturnIndex,
        [Parameter(Mandatory=$true)] [string] $FormTitle,
        [Parameter(Mandatory=$false)] [string] $ButtonText = "OK"
    )
    begin {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
    }
    process {
        $ComboBoxSize = New-Object System.Drawing.Size
        $ComboBoxSize.Height = 20
        $ComboBoxSize.Width = 300

        $ComboBoxPosition = New-Object -TypeName System.Drawing.Point
        $ComboBoxPosition.X = 10
        $ComboBoxPosition.Y = 10

        $ComboBox = New-Object -TypeName System.Windows.Forms.ComboBox
        $ComboBox.Location = $ComboBoxPosition
        $ComboBox.DataBindings.DefaultDataSourceUpdateMode = 0
        $ComboBox.FormattingEnabled = $true
        $ComboBox.Name = "comboBox1"
        $ComboBox.TabIndex = 0
        $ComboBox.Size = $ComboBoxSize
        
        $Items | foreach {
            $ComboBox.Items.Add($_)
            $ComboBox.SelectedIndex = 0
        } | Out-Null

        $ButtonSize = New-Object -TypeName System.Drawing.Size
        $ButtonSize.Height = 23
        $ButtonSize.Width = 60
        
        $ButtonPosition = New-Object -TypeName System.Drawing.Point
        $ButtonPosition.X = 320
        $ButtonPosition.Y = 9
        
        $ButtonOnClick = {
            $global:SelectedItem = $ComboBox.SelectedItem
            $global:SelectedIndex = $ComboBox.SelectedIndex
            $Form.Close()
        }

        $Button = New-Object -TypeName System.Windows.Forms.Button
        $Button.TabIndex = 2
        $Button.Size = $ButtonSize
        $Button.Name = "button1"
        $Button.UseVisualStyleBackColor = $true
        $Button.Text = $ButtonText
        $Button.Location = $ButtonPosition
        $Button.DataBindings.DefaultDataSourceUpdateMode = 0
        $Button.add_Click($ButtonOnClick)

        $FormSize = New-Object -TypeName System.Drawing.Size
        $FormSize.Height = 40
        $FormSize.Width = 390

        $Form = New-Object -TypeName System.Windows.Forms.Form
        $Form.AutoScaleMode = 0
        $Form.Text = $FormTitle
        $Form.Name = "form1"
        $Form.DataBindings.DefaultDataSourceUpdateMode = 0
        $Form.ClientSize = $FormSize
        $Form.FormBorderStyle = 1
        $Form.Controls.Add($Button)
        $Form.Controls.Add($ComboBox)

        $Form.ShowDialog() | Out-Null
    }
    end {
        $SelectedItem = $global:SelectedItem
        $SelectedIndex = $global:SelectedIndex
        Clear-Variable -Name "SelectedItem" -Force -Scope global
        if ($ReturnIndex) {
            return $SelectedIndex
        } else {
            return $SelectedItem
        }
    }
}
$Selection = Show-ComboBox -Items ("Bauantrag") -FormTitle "Bitte treffe eine Auswahl" -ButtonText "OK" -ReturnIndex
$Selection