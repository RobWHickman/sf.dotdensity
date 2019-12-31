#' Electoral Data to replicate Paul Campbell's blogpost
#'
#' A dataset containing the results of the 2017 UK General Election in London
#'  with votes for major parties by the seat in the House of Commons
#'
#' \itemize{
#'   \item{ons_id}{The Office of National Statistics id for the constituency}
#'   \item{constituency_name}{The plain language name of the constituency seat}
#'   \item{first_party}{The parliamentary party with the most votes for a given seat}
#'   \item{Con}{The number of votes won by the Conservative party for a given seat}
#'   \item{Lab}{The number of votes won by the Labour party for a given seat}
#'   \item{LD}{The number of votes won by the Liberal Democrats party for a given seat}
#'   \item{UKIP}{The number of votes won by the UKIP party for a given seat}
#'   \item{Green}{The number of votes won by the Green party for a given seat}
#' }
#'
#' @docType data
#' @keywords datasets
#' @name london_election_data
#' @usage data(london_election_data)
#' @format A data frame with 73 rows and 8 variables
"london_election_data"
