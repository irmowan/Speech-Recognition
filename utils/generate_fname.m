function fname = generate_fname(id, word, no)
fname = strcat('SpeechDataset/', id, '/', id, '_', word, '_', no, '.wav');
return