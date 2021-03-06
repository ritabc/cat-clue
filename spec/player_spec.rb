require('spec_helper')

describe(Player) do
  context('#end_turn') do
    it('will switch turns from the current player to the next player') do
      player1 = Player.find_by(name: 'Player 1')
      player2 = Player.find_by(name: 'Player 2')
      player3 = Player.find_by(name: 'Player 3')
      player4 = Player.find_by(name: 'Player 4')
      player1.update(turn: 'f')
      player2.update(turn: 'f')
      player3.update(turn: 'f')
      player4.update(turn: 't')
      player4.end_turn
      player1 = Player.find_by(name: 'Player 1')
      player4 = Player.find_by(name: 'Player 4')
      expect(player1.turn).to(eq(true))
      expect(player4.turn).to(eq(false))
    end
  end
  context '#roll_dice' do
    it 'will return a number between 1 and 6' do
      player1 = Player.create({:dice_roll => nil})
      player1.roll_dice
      expect(player1.dice_roll).to be_between(1,6).inclusive
      player1.roll_dice
      expect(player1.dice_roll).to be_between(1,6).inclusive
      player1.roll_dice
      expect(player1.dice_roll).to be_between(1,6).inclusive
      player1.roll_dice
      expect(player1.dice_roll).to be_between(1,6).inclusive
    end
  end

  context '#player_guess_match' do
    it 'will take the players guesses and return a card if unkown to player' do
      Card.murder
      Card.deal_cards
      player1 = Player.all.first
      cat_card = Card.where(answer: 'f', card_type: 'Cat').where.not(player_id: player1.id).first
      weapon_card = Card.where(answer: 'f', card_type: 'Weapon').where.not(player_id: player1.id).first
      room_card = Card.where(answer: 'f', card_type: 'Room').where.not(player_id: player1.id).first
      player_guess = [cat_card, weapon_card, room_card]
      player_match = player1.player_guess_match(cat_card, weapon_card, room_card)
      expect(player_guess).to include(player_match)
    end
  end

  context ('#available_spaces where current_space is a hall') do
    it('will check available_spaces which a player can move to') do
      player = Player.find_by(name: 'Player 1')
      space = Space.find_by(coordinates: 'D4')
      space.update(player_id: player.id)
      adjacent_spaces = []
      Space.where("coordinates = 'D3' OR coordinates = 'F4' OR coordinates = 'C4' OR coordinates = 'D5'").each do |adj_space|
        adjacent_spaces.push(adj_space)
      end
      expect(player.available_spaces(space.coordinates)).to(eq(adjacent_spaces))
    end
  end

  context ('#available_spaces where current_space is on a door') do
    it('will check available_spaces which a player can move to') do
      player = Player.find_by(name: 'Player 1')
      space = Space.find_by(coordinates: 'B3')
      space.update(player_id: player.id)
      adjacent_spaces = []
      Space.where("coordinates = 'B2' OR coordinates = 'C3' OR coordinates = 'A3'").each do |adj_space|
        adjacent_spaces.push(adj_space)
      end
      expect(player.available_spaces(space.coordinates)).to(eq(adjacent_spaces))
    end
  end

  context ('#available_spaces where current_space is in a room') do
    it('will check available_spaces which a player can move to') do
      player = Player.find_by(name: 'Player 1')
      space = Space.find_by(coordinates: 'B2')
      space.update(player_id: player.id)
      adjacent_spaces = []
      Space.where("coordinates = 'B1' OR coordinates = 'A2' OR coordinates = 'B3'").each do |adj_space|
        adjacent_spaces.push(adj_space)
      end
      expect(player.available_spaces(space.coordinates)).to(eq(adjacent_spaces))
    end
  end
end
