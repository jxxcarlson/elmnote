module ParseTime exposing (parseDateRecord)

import Parser exposing (..)
import Derberos.Date.Core exposing (DateRecord)
import Time


-- "2018-11-11T14:22:40"


parseDateRecord : Parser DateRecord
parseDateRecord =
    succeed DateRecord
        |= int
        |. symbol "-"
        |= int
        |. symbol "-"
        |= int
        |. symbol "T"
        |= int
        |. symbol ":"
        |= int
        |. symbol ":"
        |= int
        |= succeed 0
        |= succeed Time.utc
