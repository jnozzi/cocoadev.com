I'm trying to get random numbers and it seems that it's always the same number I get from rand() over and over. I initialize the seed at the beginning, in awakeFromNib, with this :
<code>
srand(time(NULL));
</code>

Can anyone explain ?

-- Trax

See [[HowToGenerateRandomNumbers]] for more information.