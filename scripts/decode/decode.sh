#!/bin/sh

# Expects a key like 
# KAIAAAEA9QYAABUiJC8VB0sBb4g9ojubMsOxVPPKyMcdQ9exiz8nTynezUtBSVUmis6eCHhCzl8cioGM+4HoYnBG7E3a7bPkMuH3nodenmxpMB6Oe6/gIVg2C/XomUZEIoEaB9+bJUbkRzxCckmurvs4E2EDU+uHQES23a3ZGTxZVUSFE9o686nEqqDnzzYNwNBk+PuEU6xinIZuK4jqO94MDOsvzRBt0OskW99ECeu6hV/7r7TV14SndSBPpzl9/JwuH2JIaD2E5yil4udDFu41mjdmMfvVawc1vB00ybtAmqFZOJgiVvIp92mGtIKDEFXbw16+bcoN961l10XX5PRCjqC8IifgcPxxkNF8FPXJ9F6w4Nnt5iJ4wyi/6FdU9wAA

# In file $1

< $1 base64 --decode > $1.bin

xxd -c20 -g4 -u $1.bin


