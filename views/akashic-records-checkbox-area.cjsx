{React, ReactBootstrap, jQuery} = window
{Panel, Button, Col, Input, Grid, Row} = ReactBootstrap

AkashicRecordsCheckboxArea = React.createClass
  getInitialState: ->
    rowChooseChecked: [true, true, true, true, true, true, true, true, true, true, true, true,
                      true, true]
  handleClickCheckbox: (index) ->
    {rowChooseChecked} = @state
    rowChooseChecked[index] = !rowChooseChecked[index]
    @setState {rowChooseChecked}
    @props.filterRules(rowChooseChecked)
  render: ->
    <div id='akashic-records-settings'>
      <Grid id='akashic-records-filter'>
        <Row>
        {
          for checkedVal, index in @props.tableTab
            continue if !index
            <Col key={index} xs={2}>
              <input type='checkbox' value={index} onChange={@handleClickCheckbox.bind(@, index)} checked={@state.rowChooseChecked[index]} style={{verticalAlign: 'middle';}}>
                {checkedVal}
              </input>
            </Col>
        }
        </Row>
      </Grid>
    </div>

module.exports = AkashicRecordsCheckboxArea