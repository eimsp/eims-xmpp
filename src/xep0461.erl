%% Created automatically by XML generator (fxml_gen.erl)
%% Source: xmpp_codec.spec

-module(xep0461).

-compile(export_all).

do_decode(<<"body">>, <<"urn:xmpp:feature-fallback:0">>,
          El, Opts) ->
    decode_feature_fallback_body(<<"urn:xmpp:feature-fallback:0">>,
                                 Opts,
                                 El);
do_decode(<<"fallback">>,
          <<"urn:xmpp:feature-fallback:0">>, El, Opts) ->
    decode_feature_fallback(<<"urn:xmpp:feature-fallback:0">>,
                            Opts,
                            El);
do_decode(<<"reply">>, <<"urn:xmpp:reply:0">>, El,
          Opts) ->
    decode_reply(<<"urn:xmpp:reply:0">>, Opts, El);
do_decode(Name, <<>>, _, _) ->
    erlang:error({xmpp_codec, {missing_tag_xmlns, Name}});
do_decode(Name, XMLNS, _, _) ->
    erlang:error({xmpp_codec, {unknown_tag, Name, XMLNS}}).

tags() ->
    [{<<"body">>, <<"urn:xmpp:feature-fallback:0">>},
     {<<"fallback">>, <<"urn:xmpp:feature-fallback:0">>},
     {<<"reply">>, <<"urn:xmpp:reply:0">>}].

do_encode({reply, _, _} = Reply, TopXMLNS) ->
    encode_reply(Reply, TopXMLNS);
do_encode({feature_fallback, _, _} = Fallback,
          TopXMLNS) ->
    encode_feature_fallback(Fallback, TopXMLNS);
do_encode({feature_fallback_body, _, _} = Body,
          TopXMLNS) ->
    encode_feature_fallback_body(Body, TopXMLNS).

do_get_name({feature_fallback, _, _}) -> <<"fallback">>;
do_get_name({feature_fallback_body, _, _}) ->
    <<"body">>;
do_get_name({reply, _, _}) -> <<"reply">>.

do_get_ns({feature_fallback, _, _}) ->
    <<"urn:xmpp:feature-fallback:0">>;
do_get_ns({feature_fallback_body, _, _}) ->
    <<"urn:xmpp:feature-fallback:0">>;
do_get_ns({reply, _, _}) -> <<"urn:xmpp:reply:0">>.

pp(reply, 2) -> [id, to];
pp(feature_fallback, 2) -> [for, body];
pp(feature_fallback_body, 2) -> [start, 'end'];
pp(_, _) -> no.

records() ->
    [{reply, 2},
     {feature_fallback, 2},
     {feature_fallback_body, 2}].

dec_int(Val, Min, Max) ->
    case erlang:binary_to_integer(Val) of
        Int when Int =< Max, Min == infinity -> Int;
        Int when Int =< Max, Int >= Min -> Int
    end.

enc_int(Int) -> erlang:integer_to_binary(Int).

decode_feature_fallback_body(__TopXMLNS, __Opts,
                             {xmlel, <<"body">>, _attrs, _els}) ->
    {Start, End} =
        decode_feature_fallback_body_attrs(__TopXMLNS,
                                           _attrs,
                                           undefined,
                                           undefined),
    {feature_fallback_body, Start, End}.

decode_feature_fallback_body_attrs(__TopXMLNS,
                                   [{<<"start">>, _val} | _attrs], _Start,
                                   End) ->
    decode_feature_fallback_body_attrs(__TopXMLNS,
                                       _attrs,
                                       _val,
                                       End);
decode_feature_fallback_body_attrs(__TopXMLNS,
                                   [{<<"end">>, _val} | _attrs], Start, _End) ->
    decode_feature_fallback_body_attrs(__TopXMLNS,
                                       _attrs,
                                       Start,
                                       _val);
decode_feature_fallback_body_attrs(__TopXMLNS,
                                   [_ | _attrs], Start, End) ->
    decode_feature_fallback_body_attrs(__TopXMLNS,
                                       _attrs,
                                       Start,
                                       End);
decode_feature_fallback_body_attrs(__TopXMLNS, [],
                                   Start, End) ->
    {decode_feature_fallback_body_attr_start(__TopXMLNS,
                                             Start),
     decode_feature_fallback_body_attr_end(__TopXMLNS, End)}.

encode_feature_fallback_body({feature_fallback_body,
                              Start,
                              End},
                             __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:feature-fallback:0">>,
                                    [],
                                    __TopXMLNS),
    _els = [],
    _attrs = encode_feature_fallback_body_attr_end(End,
                                                   encode_feature_fallback_body_attr_start(Start,
                                                                                           xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                                                                      __TopXMLNS))),
    {xmlel, <<"body">>, _attrs, _els}.

decode_feature_fallback_body_attr_start(__TopXMLNS,
                                        undefined) ->
    erlang:error({xmpp_codec,
                  {missing_attr, <<"start">>, <<"body">>, __TopXMLNS}});
decode_feature_fallback_body_attr_start(__TopXMLNS,
                                        _val) ->
    case catch dec_int(_val, 0, infinity) of
        {'EXIT', _} ->
            erlang:error({xmpp_codec,
                          {bad_attr_value,
                           <<"start">>,
                           <<"body">>,
                           __TopXMLNS}});
        _res -> _res
    end.

encode_feature_fallback_body_attr_start(_val, _acc) ->
    [{<<"start">>, enc_int(_val)} | _acc].

decode_feature_fallback_body_attr_end(__TopXMLNS,
                                      undefined) ->
    erlang:error({xmpp_codec,
                  {missing_attr, <<"end">>, <<"body">>, __TopXMLNS}});
decode_feature_fallback_body_attr_end(__TopXMLNS,
                                      _val) ->
    case catch dec_int(_val, 0, infinity) of
        {'EXIT', _} ->
            erlang:error({xmpp_codec,
                          {bad_attr_value, <<"end">>, <<"body">>, __TopXMLNS}});
        _res -> _res
    end.

encode_feature_fallback_body_attr_end(_val, _acc) ->
    [{<<"end">>, enc_int(_val)} | _acc].

decode_feature_fallback(__TopXMLNS, __Opts,
                        {xmlel, <<"fallback">>, _attrs, _els}) ->
    Body = decode_feature_fallback_els(__TopXMLNS,
                                       __Opts,
                                       _els,
                                       undefined),
    For = decode_feature_fallback_attrs(__TopXMLNS,
                                        _attrs,
                                        undefined),
    {feature_fallback, For, Body}.

decode_feature_fallback_els(__TopXMLNS, __Opts, [],
                            Body) ->
    Body;
decode_feature_fallback_els(__TopXMLNS, __Opts,
                            [{xmlel, <<"body">>, _attrs, _} = _el | _els],
                            Body) ->
    case xmpp_codec:get_attr(<<"xmlns">>,
                             _attrs,
                             __TopXMLNS)
        of
        <<"urn:xmpp:feature-fallback:0">> ->
            decode_feature_fallback_els(__TopXMLNS,
                                        __Opts,
                                        _els,
                                        decode_feature_fallback_body(<<"urn:xmpp:feature-fallback:0">>,
                                                                     __Opts,
                                                                     _el));
        _ ->
            decode_feature_fallback_els(__TopXMLNS,
                                        __Opts,
                                        _els,
                                        Body)
    end;
decode_feature_fallback_els(__TopXMLNS, __Opts,
                            [_ | _els], Body) ->
    decode_feature_fallback_els(__TopXMLNS,
                                __Opts,
                                _els,
                                Body).

decode_feature_fallback_attrs(__TopXMLNS,
                              [{<<"for">>, _val} | _attrs], _For) ->
    decode_feature_fallback_attrs(__TopXMLNS, _attrs, _val);
decode_feature_fallback_attrs(__TopXMLNS, [_ | _attrs],
                              For) ->
    decode_feature_fallback_attrs(__TopXMLNS, _attrs, For);
decode_feature_fallback_attrs(__TopXMLNS, [], For) ->
    decode_feature_fallback_attr_for(__TopXMLNS, For).

encode_feature_fallback({feature_fallback, For, Body},
                        __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:feature-fallback:0">>,
                                    [],
                                    __TopXMLNS),
    _els =
        lists:reverse('encode_feature_fallback_$body'(Body,
                                                      __NewTopXMLNS,
                                                      [])),
    _attrs = encode_feature_fallback_attr_for(For,
                                              xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                         __TopXMLNS)),
    {xmlel, <<"fallback">>, _attrs, _els}.

'encode_feature_fallback_$body'(undefined, __TopXMLNS,
                                _acc) ->
    _acc;
'encode_feature_fallback_$body'(Body, __TopXMLNS,
                                _acc) ->
    [encode_feature_fallback_body(Body, __TopXMLNS) | _acc].

decode_feature_fallback_attr_for(__TopXMLNS,
                                 undefined) ->
    <<>>;
decode_feature_fallback_attr_for(__TopXMLNS, _val) ->
    _val.

encode_feature_fallback_attr_for(<<>>, _acc) -> _acc;
encode_feature_fallback_attr_for(_val, _acc) ->
    [{<<"for">>, _val} | _acc].

decode_reply(__TopXMLNS, __Opts,
             {xmlel, <<"reply">>, _attrs, _els}) ->
    {Id, To} = decode_reply_attrs(__TopXMLNS,
                                  _attrs,
                                  undefined,
                                  undefined),
    {reply, Id, To}.

decode_reply_attrs(__TopXMLNS,
                   [{<<"id">>, _val} | _attrs], _Id, To) ->
    decode_reply_attrs(__TopXMLNS, _attrs, _val, To);
decode_reply_attrs(__TopXMLNS,
                   [{<<"to">>, _val} | _attrs], Id, _To) ->
    decode_reply_attrs(__TopXMLNS, _attrs, Id, _val);
decode_reply_attrs(__TopXMLNS, [_ | _attrs], Id, To) ->
    decode_reply_attrs(__TopXMLNS, _attrs, Id, To);
decode_reply_attrs(__TopXMLNS, [], Id, To) ->
    {decode_reply_attr_id(__TopXMLNS, Id),
     decode_reply_attr_to(__TopXMLNS, To)}.

encode_reply({reply, Id, To}, __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:reply:0">>,
                                    [],
                                    __TopXMLNS),
    _els = [],
    _attrs = encode_reply_attr_to(To,
                                  encode_reply_attr_id(Id,
                                                       xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                                  __TopXMLNS))),
    {xmlel, <<"reply">>, _attrs, _els}.

decode_reply_attr_id(__TopXMLNS, undefined) -> <<>>;
decode_reply_attr_id(__TopXMLNS, _val) -> _val.

encode_reply_attr_id(<<>>, _acc) -> _acc;
encode_reply_attr_id(_val, _acc) ->
    [{<<"id">>, _val} | _acc].

decode_reply_attr_to(__TopXMLNS, undefined) ->
    erlang:error({xmpp_codec,
                  {missing_attr, <<"to">>, <<"reply">>, __TopXMLNS}});
decode_reply_attr_to(__TopXMLNS, _val) ->
    case catch jid:decode(_val) of
        {'EXIT', _} ->
            erlang:error({xmpp_codec,
                          {bad_attr_value, <<"to">>, <<"reply">>, __TopXMLNS}});
        _res -> _res
    end.

encode_reply_attr_to(_val, _acc) ->
    [{<<"to">>, jid:encode(_val)} | _acc].
