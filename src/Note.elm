module Note exposing (Note, noteDecoder, noteListDecoder)

import Json.Decode as D
import Derberos.Date.Core exposing (DateRecord)
import DateTime as DT


type alias Note =
    { id : String
    , title : String
    , content : String
    , dateModified : DateRecord
    , dateCreated : DateRecord
    }


noteListDecoder : D.Decoder (List Note)
noteListDecoder =
    D.list noteDecoder


noteDecoder : D.Decoder Note
noteDecoder =
    D.map5 Note
        (D.field "id" D.string)
        (D.field "title" D.string)
        (D.field "note" D.string)
        ((D.field "created_on" D.string) |> D.map DT.dateRecordOfString)
        ((D.field "modfied_on" D.string) |> D.map DT.dateRecordOfString)



{-

   [{"id":"15e7bfee-c195-4310-bf08-f1f7f0ebee4b","created_on":"2018-11-11T14:22:40","modfied_on":"2018-11-11T14:22:40","title":"Why Competition in the Politics Industry is Failing America","note":"Why Competition in the Politics Industry is Failing America\nHarvard Business School Review\nhttps://www.hbs.edu/competitiveness/Documents/why-competition-in-the-politics-industry-is-failing-america.pdf"}]

-}
