I noticed that everytime I play a sound in one of my apps, there is a delay before the sound is played for the first time after the app is launched.
Is there a way to preload a sound so there isn't any loading delay ?

-- Trax

I assume you're using General/NSSound. I guess the answer-- useful or no-- would be to stop using General/NSSound and use General/QuickTime instead... but then you incur a ton of other penalties. General/NSSound is lazy... but easy.

-- General/RobRix

I've found that if the sound is not encoded at 44100 Hz, 16-bit stereo, then some behind-the-scenes conversion seems to be taking place. I converted all of my sounds in a recent app to 44.1 and the delays went away (for the most part).

-- Tantle

Personally, I'm a bit reluctant to use QT since I discovered that it can't play MP3s correctly... But you're probably right, General/RobRix. By the way, what are those "other penalties" of using General/QuickTime for sounds ?

-- Trax

Well, General/NSSound is probably using either General/QuickTime or General/CoreAudio, and General/QuickTime is probably using General/CoreAudio, but... The other penalties can be summed up as "complexity." General/NSSound is ripe for simple, one-line statements. General/QuickTime is *not*. You might also try one of the multitude of MP3 decoders available in source form if that's all you need... mpg123, I hear, works well.

-- General/RobRix

I heard about mpg123, but I still can't figure what to do with the 70 files contained in the package. And how to implement it in General/CoreAudio or General/QuickTime to get some results.

-- Trax

I can show you the door... but you're the one who has to walk through it (; Which is to say: you're already more experienced with it than I am. So play with it! And hopefully somebody more knowledgeable than I will be able to help also.

-- General/RobRix