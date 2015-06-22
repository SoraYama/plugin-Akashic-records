{React, ReactBootstrap, path, ROOT} = window
{Grid, Row, Col, Table, ButtonGroup, DropdownButton, MenuItem, Input, Pager, PageItem} = ReactBootstrap
{log, warn, error} = require path.join(ROOT, 'lib/utils')

AkashicRecordsTableTbodyItem = React.createClass
  render: ->
    <tr>
      <td>{@props.index}</td>
      {
        for item,index in @props.data
          if index is 0 and @props.rowChooseChecked[1]
            <td>{(new Date(item)).toString()}</td>
          else
            <td>{item}</td> if @props.rowChooseChecked[index+1] 
      }
    </tr>

AkashicRecordsTableArea = React.createClass
  getInitialState: ->
    dataShow: []
    showAmount: 10
    filterKey: ''
    pageIndex: 0
  _filter: (rawData, keyWord)->
    {rowChooseChecked} = @props
    if keyWord?
      rawData.filter (row)->
        match = false
        for item, index in row
          continue if index is 0
          if rowChooseChecked[index+1]
            if item.toLowerCase().trim().indexOf(keyWord.toLowerCase().trim()) >= 0
              match = true
        match
    else rawData
  _filterBy: (keyWord)->
    dataShow = @_filter @props.data, keyWord
    @setState 
      dataShow: dataShow
      filterKey: keyWord
  handleKeyWordChange: ->
    keyWord = @refs.input.getValue()
    @_filterBy keyWord
  componentWillMount: ->
    log "componentWillMount"
    if @props.data.length > 0
      pageIndex = 1
    else pageIndex = 0
    @setState 
      dataShow: @props.data
      filterKey: ''
      pageIndex: pageIndex
  componentWillReceiveProps: (nextProps)->
    dataShow = @_filter nextProps.data, @filterKey
    {pageIndex} = @state
    if pageIndex < 1
      pageIndex = 1
    if pageIndex > Math.ceil(dataShow.length/@state.showAmount)
      pageIndex = Math.ceil(dataShow.length/@state.showAmount)
    console.log "this point"
    @setState
      dataShow: dataShow
      pageIndex: pageIndex
  handleShowAmountSelect: (selectedKey)->
    {pageIndex} = @state    
    if pageIndex < 0
      pageIndex = 1
    if pageIndex > Math.ceil(@state.dataShow.length/selectedKey)
      pageIndex = Math.ceil(@state.dataShow.length/selectedKey)
    @setState
      showAmount: selectedKey
      pageIndex: pageIndex
  handleShowPageSelect: (selectedKey)->
    if selectedKey is 0
      selectedKey = 1
    else if selectedKey is -1
      selectedKey = Math.ceil(@state.dataShow.length/@state.showAmount)
    if selectedKey < 1
      selectedKey = selectedKey+1
    else if selectedKey > (Math.ceil(@state.dataShow.length/@state.showAmount))
      selectedKey = Math.ceil(@state.dataShow.length/@state.showAmount)
    @setState
      pageIndex: selectedKey
  render: ->
    <div>
      <Grid>
        <Row>
          <Col xs={3}>
            <ButtonGroup justified>
              <DropdownButton center eventKey={4} title={"显示#{@state.showAmount}条"} block>
                <MenuItem center eventKey=10 onSelect={@handleShowAmountSelect}>{"显示10条"}</MenuItem>
                <MenuItem eventKey=20 onSelect={@handleShowAmountSelect}>{"显示20条"}</MenuItem>
                <MenuItem eventKey=50 onSelect={@handleShowAmountSelect}>{"显示50条"}</MenuItem>
                <MenuItem divider />
                <MenuItem eventKey=0 onSelect={@handleShowAmountSelect}>{"显示全部"}</MenuItem>
              </DropdownButton>
            </ButtonGroup>
          </Col>
          <Col xs={3}>
            <ButtonGroup justified>
              <DropdownButton eventKey={4} title={"第#{@state.pageIndex}页"} block>
              {
                if @state.dataShow.length isnt 0
                  for index in [1..Math.ceil(@state.dataShow.length/@state.showAmount)]
                    <MenuItem eventKey={index} onSelect={@handleShowPageSelect}>第{index}页</MenuItem>
              } 
              </DropdownButton>
            </ButtonGroup>
          </Col>
          <Col xs={6}>
            <Input
              type='text'
              value={@state.filterKey}
              placeholder='关键词'
              hasFeedback
              ref='input'
              onChange={@handleKeyWordChange} />
          </Col>
        </Row>
        <Row>
          <Col xs={12}>
            <Table striped bordered condensed hover Responsive>
              <thead>
                <tr>
                  {
                    for tab, index in @props.tableTab
                      <th>{tab}</th> if @props.rowChooseChecked[index]
                  }
                </tr>
              </thead>
              <tbody>
                { if @state.pageIndex > 0
                    for item, index in @state.dataShow.slice((@state.pageIndex-1)*@state.showAmount, @state.pageIndex*@state.showAmount)
                      <AkashicRecordsTableTbodyItem 
                        key = {index}
                        index = {(@state.pageIndex-1)*@state.showAmount+index+1};
                        data={item} 
                        rowChooseChecked={@props.rowChooseChecked}
                      />
                }
              </tbody>
            </Table>
          </Col>
        </Row>
        <Row> 
          <Pager activeKey={0}>
            <PageItem previous eventKey={0} onSelect={@handleShowPageSelect}>&larr; First Page</PageItem>
            {
              if @state.pageIndex < 5
                for i in [1..5]
                  break if i > Math.ceil(@state.dataShow.length/@state.showAmount) 
                  <PageItem eventKey={i} onSelect={@handleShowPageSelect}>{i}</PageItem>
              else if @state.pageIndex > (Math.ceil(@state.dataShow.length/@state.showAmount)-2)
                for i in [Math.ceil(@state.dataShow.length/@state.showAmount)-4..Math.ceil(@state.dataShow.length/@state.showAmount)]
                  continue if i<1
                  <PageItem eventKey={i} onSelect={@handleShowPageSelect}>{i}</PageItem>
              else 
                for i in [@state.pageIndex-2..@state.pageIndex+2]
                  <PageItem eventKey={i} onSelect={@handleShowPageSelect}>{i}</PageItem>
            }
            <PageItem next eventKey={-1} onSelect={@handleShowPageSelect}>Last Page &rarr;</PageItem>
          </Pager>
        </Row>

      </Grid>
    </div>

module.exports = AkashicRecordsTableArea