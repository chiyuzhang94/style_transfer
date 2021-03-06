train_src=/corpora/yahoo_answers/final_data/Entertainment_Music/train/answers.entertainment_music.batches_1_30.6x.Entertainment_Music.sents.batch000_732.gt10editdist.filtered.smt.informal
train_tgt=/corpora/yahoo_answers/final_data/Entertainment_Music/train/answers.entertainment_music.batches_1_30.6x.Entertainment_Music.sents.batch000_732.gt10editdist.filtered.smt.formal
valid_src=/corpora/yahoo_answers/final_data/Entertainment_Music/tune/answers.Entertainment_Music.sents.batch50_60.2x.tok.informal
valid_tgt=/corpora/yahoo_answers/final_data/Entertainment_Music/tune/answers.Entertainment_Music.sents.batch50_60.filtered.ref0.ref1.tok.formal

save_data=/corpora/yahoo_answers/final_data/Entertainment_Music/OpenNMT-lua/answers.entertainment_music.batches_1_30.6x.answers.Entertainment_Music.sents.batch000_732.gt10editdist.filtered.smt

th preprocess.lua -train_src $train_src -train_tgt $train_tgt -valid_src $valid_src -valid_tgt $valid_tgt -save_data $save_data

th tools/embeddings.lua -embed_type glove -embed_file /corpora/yahoo_answers/All_Yahoo_Answers/All_Yahoo_Answers.vectors_300.txt -dict_file $save_data.src.dict -save_data $save_data.src.answer.emb

th tools/embeddings.lua -embed_type glove -embed_file /corpora/yahoo_answers/All_Yahoo_Answers/All_Yahoo_Answers.vectors_300.txt -dict_file $save_data.tgt.dict -save_data $save_data.tgt.answer.emb

th train.lua -encoder_type brnn -data $save_data-train.t7 -save_model $save_data.model -pre_word_vecs_enc $save_data.src.answer.emb-embeddings-300.t7 -src_word_vec_size 300 -pre_word_vecs_dec $save_data.tgt.answer.emb-embeddings-300.t7 -tgt_word_vec_size 300 -fix_word_vecs_enc -fix_word_vecs_dec -end_epoch 30 -gpuid 1

th train.lua -encoder_type brnn -dropout_input true -data $save_data-train.t7 -save_model $save_data.model -pre_word_vecs_enc $save_data.src.answer.emb-embeddings-300.t7 -src_word_vec_size 300 -pre_word_vecs_dec $save_data.tgt.answer.emb-embeddings-300.t7 -tgt_word_vec_size 300 -end_epoch 30 -gpuid 1

