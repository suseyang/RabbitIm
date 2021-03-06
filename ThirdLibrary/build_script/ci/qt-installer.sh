#!/bin/bash

set -e #quit on error

if [ $# -lt 2 ];
then
    echo qt-installer.sh qt-installer output_path
    exit -1
fi

export PATH=$PATH:$PWD
export WORKDIR=$PWD
INSTALLER=$1
OUTPUT=$2
SCRIPT="$(mktemp /tmp/tmp.XXXXXXXXX)"

cat <<EOF > $SCRIPT
function Controller() {
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    });
}

Controller.prototype.WelcomePageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.CommitButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();

    // widget.deselectAll();

    gui.clickButton(buttons.NextButton);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}


Controller.prototype.TargetDirectoryPageCallback = function() {
    var widget = gui.currentPageWidget();

    if (widget != null) {
        widget.TargetDirectoryLineEdit.setText("$OUTPUT");
    }

    gui.clickButton(buttons.NextButton);

}

Controller.prototype.LicenseAgreementPageCallback = function() {
    var widget = gui.currentPageWidget();

    if (widget != null) {
        widget.AcceptLicenseRadioButton.setChecked(true);
    }

    gui.clickButton(buttons.NextButton);

}

Controller.prototype.ReadyForInstallationPageCallback = function() {

    gui.clickButton(buttons.CommitButton);
}

Controller.prototype.FinishedPageCallback = function() {
    var widget = gui.currentPageWidget();
    widget.LaunchQtCreatorCheckBoxForm.launchQtCreatorCheckBox.setChecked(false);
    gui.clickButton(buttons.FinishButton);
}
EOF

chmod u+x $1
$1 --script $SCRIPT
