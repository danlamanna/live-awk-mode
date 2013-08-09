live-awk-mode
=============

Build awk commands interactively with live result sets.

## Installation

Make sure live-awk.el is on your load path, then add a hook like so:    

    (add-hook 'awk-mode-hook (lambda()
                               (require 'live-awk)
                               (live-awk-mode 1)))
                               
## Usage    
Open an awk-mode buffer, and live-awk will prompt you for an input file, this is the file your awk command 
will be run on.   

On editing the awk command, when the buffer changes and doesn't produce anything to stderr, the buffer is updated
with the latest output sent to stdout.   
   
## The Good    
It (sort of) works!    
    
    
## The Bad    
- It's messy. 
- It requires `head` be installed on the machine.
- The results pop up in an obtrusive window.
- It uses `live-awk-max-lines` because large data sets would cause emacs to halt.
- The input file <-> awk buffer relationship is one to one.

## Contribution Ideas
- Setting it up to use proper emacs processes (`start-process`)
- Possible integration with vlfi for large result sets.
- Cleaning up popup window, maybe using `popwin` or at least, read-only buffers.
- Perhaps highlighting in the result set of where the cursor in the `awk-mode` buffer corresponds to.
