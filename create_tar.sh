#!/bin/sh

git archive --format=tar.gz --prefix=tb.settings-$1/ tags/$1 -o tb.settings-$1.tar.gz
